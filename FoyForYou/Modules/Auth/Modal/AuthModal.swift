//
//  AuthModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 21/08/25.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case passwordMismatch
    case userAlreadyExists
    case userNotFound
    case authDefaultError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Invalid email format"
        case .invalidPassword: return "Password must be 6+ chars with uppercase, lowercase & number"
        case .passwordMismatch: return "Passwords do not match"
        case .userAlreadyExists: return "User already exists"
        case .userNotFound: return "User not found"
        case .authDefaultError(let message): return message
        
        }
    }
}
