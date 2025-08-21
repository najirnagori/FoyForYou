//
//  CartViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showDeleteAlert = false
    @Published var itemToDeleteIndex: Int?
    @Published var goToCheckout: Bool = false
    
    private let coreDataManager = CoreDataManager.shared
    private var currentUser: User?
    
    init() {
        getCurrentUser()
        loadCartItems()
    }
    
    func loadCartItems() {
        isLoading = true
        errorMessage = nil
        
        if let user = currentUser {
            do {
                cartItems = try coreDataManager.fetchCartItems(for: user)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            errorMessage = "Please log in to view your cart"
            cartItems = []
        }
        
        isLoading = false
    }
    
    func updateQuantity(for item: CartItem, cartItemIndex: Int ,newQuantity: Int) {
        guard newQuantity > 0 else {
            removeItem(cartItemIndex)
            return
        }
        
        if coreDataManager.updateCartItemQuantity(item: item, newQuantity: newQuantity) {
            // Update local state
            if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
                cartItems[index].quantity = Int32(newQuantity)
                objectWillChange.send()
            }
        } else {
            errorMessage = "Failed to update quantity"
        }
    }
    
    func increaseQuantity(for item: CartItem, cartItemIndex: Int) {
        let newQuantity = Int(item.quantity) + 1
        updateQuantity(for: item, cartItemIndex: cartItemIndex, newQuantity: newQuantity)
    }
    
    func decreaseQuantity(for item: CartItem, cartItemIndex: Int) {
        let newQuantity = Int(item.quantity) - 1
        updateQuantity(for: item, cartItemIndex: cartItemIndex, newQuantity: newQuantity)
    }
    
    func removeItem(_ index: Int) {
        itemToDeleteIndex = index
        showDeleteAlert = true
    }
    
    func confirmRemoveItem() {
        guard let index = itemToDeleteIndex else { return }
        
        if coreDataManager.removeFromCart(item: cartItems[index]) {
            cartItems.remove(at: index)
        } else {
            errorMessage = "Failed to remove item"
        }
        
        itemToDeleteIndex = nil
        showDeleteAlert = false
    }
    
    func clearCart() {
        if let user = currentUser {
            if coreDataManager.clearCart(for: user) {
                cartItems.removeAll()
            } else {
                errorMessage = "Failed to clear cart"
            }
        }
    }
    
    var total: Double {
        cartItems.reduce(0) { total, item in
            total + (item.product.price) * Double(item.quantity)
        }
    }
    
    var itemCount: Int {
        cartItems.reduce(0) { count, item in
            count + Int(item.quantity)
        }
    }
    
    var isEmpty: Bool {
        cartItems.isEmpty
    }
    
    private func getCurrentUser() {
        currentUser = LocalStorage.getCurrentUser()
    }
    
    var canProceedToCheckout: Bool {
        !cartItems.isEmpty && currentUser != nil
    }
    
}
