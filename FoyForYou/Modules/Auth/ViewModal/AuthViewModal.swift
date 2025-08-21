//
//  AuthViewModal.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isLoginMode = true
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private let validator: ValidatorProtocol
    
    init(validator: ValidatorProtocol = Validator()) {
        self.validator = validator
    }
    
    private func validateEmailAndPassword() throws {
        guard validator.isValidEmail(email) else {
            throw AuthError.invalidEmail
        }
        
        guard validator.isValidPassword(password) else {
            throw AuthError.invalidPassword
        }
    }
    
    private func login() throws -> Bool {
        try validateEmailAndPassword()
        
        return try CoreDataManager.shared.authenticateUser(username: email, password: password)
        
    }
    
    private func signup() throws {
        try validateEmailAndPassword()
        
        guard confirmPassword == password else {
            throw AuthError.passwordMismatch
        }
        
        try CoreDataManager.shared.createUser(username: email, password: password)
    }
    
    func loginSignupAction() -> Bool {
        do {
            
            if isLoginMode {
                let _ = try login()
            } else {
                try signup()
            }
            LocalStorage.setCurrentUser(email)
            LocalStorage.setCurrentState(.tab)
            return true
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            return false
        }
    }
}
