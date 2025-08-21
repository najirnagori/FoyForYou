//
//  ProductDetailViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var quantity: Int = 1
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    private let coreDataManager = CoreDataManager.shared
    
    init(product: Product) {
        self.product = product
    }
    
    func addToCart() -> Bool {
        alertMessage = nil
        if let currentUser = getCurrentUser() {
            do {
                try coreDataManager.addToCart(product: product, quantity: quantity, user: currentUser)
                alertMessage = "Item added to cart successfully"
                showAlert = true
                return true
            } catch let error {
                print(error)
                alertMessage = "Failed to add item to cart"
                showAlert = true
                return false
            }
        } else {
            alertMessage = "User Not Found"
            showAlert = true
            return false
        }
    }
    
    private func getCurrentUser() -> User? {
        return LocalStorage.getCurrentUser()
    }
}
