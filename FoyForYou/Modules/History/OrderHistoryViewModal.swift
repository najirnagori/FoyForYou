//
//  OrderHistoryViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 21/08/25.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var errorMessage: String?
    
    private let coreDataManager = CoreDataManager.shared
    private var currentUser: User?
    
    init() {
        loadCurrentUser()
        loadOrders()
    }
    
    func loadOrders() {
        errorMessage = nil
        
        if let user = currentUser {
            orders = coreDataManager.fetchOrders(for: user)
        } else {
            errorMessage = "Please log in to view your order history"
            orders = []
            
        }
    }
    
    func refreshOrders() {
        loadOrders()
    }
    
    
    
    private func loadCurrentUser() {
        currentUser = LocalStorage.getCurrentUser()
    }
}
