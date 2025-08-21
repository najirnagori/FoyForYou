//
//  PaymentManager.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 20/08/25.
//

import Foundation

enum PaymentError: Error {
    case insufficientFunds
    case paymenFailed
}

protocol PaymentMethod {
    func pay(amount: Double) -> Result<String, PaymentError>
}

struct CreditCardPayment: PaymentMethod {
    
    func pay(amount: Double) -> Result<String, PaymentError> {
        return .success("💳 Paid $\(amount) using Credit Card")
    }
}

struct ApplePayPayment: PaymentMethod {
    func pay(amount: Double) -> Result<String, PaymentError> {
        return .success("🍏 Paid $\(amount) using Apple Pay")
    }
}

struct PayPalPayment: PaymentMethod {
    
    func pay(amount: Double) -> Result<String, PaymentError> {
        return .success("💲 Paid $\(amount) using PayPal")
    }
}


class PaymentManager {
    private var paymentMethod: PaymentMethod
    
    init(paymentMethod: PaymentMethod) {
        self.paymentMethod = paymentMethod
    }
    
    func makePayment(amount: Double) -> Result<String, PaymentError> {
        return paymentMethod.pay(amount: amount)
    }
}
