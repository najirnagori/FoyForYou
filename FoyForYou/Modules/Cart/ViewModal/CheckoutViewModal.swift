//
//  CheckoutViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation

class CheckoutViewModel: ObservableObject {
    @Published var orderItems: [CartItem] = []
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var showAlert = false
    @Published var shippingAddress = ""
    @Published var paymentType: PaymentType = .creditCard
    @Published var showSuccessScreen = false
    
    
    private let coreDataManager = CoreDataManager.shared
    private var currentUser: User?
    
    init(cartItems: [CartItem] = []) {
        self.orderItems = cartItems
        loadCurrentUser()
    }
    
    func authenticatePay() {
        if shippingAddress.isEmpty {
            alertMessage = "Add shipping address"
            showAlert = true
        } else {
            pay(amount: subtotal)
        }
    }
    
    private func pay(amount: Double) {
        let paymentManager = PaymentManager(paymentMethod: getPaymentMathod())
        switch paymentManager.makePayment(amount: amount) {
        case .success(let message):
            let _ = placeOrder()
            alertMessage = message
            showSuccessScreen = true
        case .failure(let error):
            print("Errro: \(error.localizedDescription)")
        }
    }
    
    private func getPaymentMathod() -> PaymentMethod {
        switch paymentType {
        case .creditCard:
            return CreditCardPayment()
        case .payPal:
            return PayPalPayment()
        case .applePay:
            return ApplePayPayment()
        }
    }
    
    private func placeOrder() -> Bool {
        
        guard let user = currentUser else {
            alertMessage = "Please log in to place an order"
            return false
        }
        
        isLoading = true
        alertMessage = nil
        
        
        if let _ = coreDataManager.createOrder(
            from: orderItems,
            user: user,
            shippingAddress: shippingAddress
        ) {
            return true
        } else {
            alertMessage = "Failed to create order. Please try again."
            isLoading = false
            return false
        }
    }
    
    var subtotal: Double {
        orderItems.reduce(0) { total, item in
            total + (item.product.price) * Double(item.quantity)
        }
    }
    
    var itemCount: Int {
        orderItems.reduce(0) { count, item in
            count + Int(item.quantity)
        }
    }
    
    private func loadCurrentUser() {
        currentUser = LocalStorage.getCurrentUser()
    }
}


enum PaymentType: CaseIterable {
    case creditCard
    case payPal
    case applePay
    
    var title: String {
        switch self {
        case .creditCard:
            return "Credit Card"
        case .payPal:
            return "PayPal"
        case .applePay:
            return "Apple Pay"
        }
    }
}
