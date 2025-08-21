//
//  CoreDataManager.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation
import CoreData
import SwiftUI

// MARK: Core Data Manager

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "FoyDataModal")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data stores: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
 
// MARK: - User Operations

extension CoreDataManager {
    
    func createUser(username: String, password: String) throws {
        let context = persistentContainer.viewContext
        
        if fetchUser(username: username) != nil {
            throw AuthError.userAlreadyExists
        }
        
        let newUser = User(context: context)
        newUser.id = UUID()
        newUser.userName = username
        newUser.password = password
        newUser.createdAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error)")
            throw AuthError.authDefaultError(error.localizedDescription)
        }
    }
    
    func fetchUser(username: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userName == %@", username)
        request.fetchLimit = 1
        
        do {
            return try viewContext.fetch(request).first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    
    func authenticateUser(username: String, password: String) throws -> Bool {
        guard let user = fetchUser(username: username) else {
            throw AuthError.userNotFound
        }
        if  user.password == password {
            return true
        } else {
            throw AuthError.authDefaultError("Incorrect Password")
        }
    }
}


    
// MARK: - Product Operations

extension CoreDataManager {
    
    func loadSampleProducts() {
        let context = persistentContainer.viewContext
        
        for (name, price, imageName, description) in sampleProducts {
            let product = Product(context: context)
            product.id = UUID()
            product.name = name
            product.price = price
            product.imageName = imageName
            product.productDescription = description
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save sample products: \(error)")
        }
    }
    
    func fetchAllProducts() -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
}
    
// MARK: - Cart Operations

extension CoreDataManager {
    
    func addToCart(product: Product, quantity: Int, user: User) throws {
        let context = persistentContainer.viewContext
        
        // Check if product is already in cart
        if let existingItem = fetchCartItem(product: product, user: user) {
            existingItem.quantity += Int32(quantity)
        } else {
            let newItem = CartItem(context: context)
            newItem.id = UUID()
            newItem.product = product
            newItem.quantity = Int32(quantity)
            newItem.dateAdded = Date()
            newItem.user = user
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to add to cart: \(error)")
            throw AuthError.authDefaultError(error.localizedDescription)
        }
    }
    
    func fetchCartItems(for user: User) throws -> [CartItem] {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch cart items: \(error)")
            throw AuthError.authDefaultError(error.localizedDescription)
        }
    }
    
    func fetchCartItem(product: Product, user: User) -> CartItem? {
        let request: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "product == %@ AND user == %@", product, user)
        request.fetchLimit = 1
        
        do {
            return try viewContext.fetch(request).first
        } catch {
            print("Failed to fetch cart item: \(error)")
            return nil
        }
    }
    
    func updateCartItemQuantity(item: CartItem, newQuantity: Int) -> Bool {
        item.quantity = Int32(newQuantity)
        
        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to update cart item: \(error)")
            return false
        }
    }
    
    func removeFromCart(item: CartItem) -> Bool {
        viewContext.delete(item)
        
        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to remove from cart: \(error)")
            return false
        }
    }
    
    func clearCart(for user: User) -> Bool {
        
        do {
            let items = try fetchCartItems(for: user)
            
            for item in items {
                viewContext.delete(item)
            }
            
            try viewContext.save()
            return true
        } catch {
            print("Failed to clear cart: \(error)")
            return false
        }
    }
}
    
// MARK: - Order Operations

extension CoreDataManager {
    
    func createOrder(from cartItems: [CartItem], user: User, shippingAddress: String) -> Order? {
        let context = persistentContainer.viewContext
        
        let newOrder = Order(context: context)
        newOrder.id = UUID()
        newOrder.date = Date()
        newOrder.totalAmount = calculateTotalAmount(for: cartItems)
        newOrder.status = "Processing"
        newOrder.shippingAddress = shippingAddress
        newOrder.user = user
        
        // Add cart items to order
        for cartItem in cartItems {
            let orderItem = CartItem(context: context)
            orderItem.id = UUID()
            orderItem.product = cartItem.product
            orderItem.quantity = cartItem.quantity
            orderItem.dateAdded = Date()
            orderItem.user = user
        }
        
        do {
            try context.save()
            // Clear cart after successful order
            _ = clearCart(for: user)
            return newOrder
        } catch {
            print("Failed to create order: \(error)")
            return nil
        }
    }
    
    func fetchOrders(for user: User) -> [Order] {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch orders: \(error)")
            return []
        }
    }
}
    
// MARK: - Helper Methods

extension CoreDataManager {
    
    private func calculateTotalAmount(for cartItems: [CartItem]) -> Double {
        cartItems.reduce(0) { total, item in
            total + (item.product.price) * Double(item.quantity)
        }
    }
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
    
// MARK: - Sample Data Initialization

extension CoreDataManager {
    
    func initializeSampleData() {
        let products = fetchAllProducts()
        if products.isEmpty {
            loadSampleProducts()
            print("Sample products loaded")
        }
    }
}
