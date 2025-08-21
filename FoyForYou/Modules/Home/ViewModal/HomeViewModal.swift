//
//  HomeViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        
        let productsFromCoreData = coreDataManager.fetchAllProducts()
        if productsFromCoreData.isEmpty {
            coreDataManager.loadSampleProducts()
            products = coreDataManager.fetchAllProducts()
        } else {
            products = productsFromCoreData
        }
    }
}
