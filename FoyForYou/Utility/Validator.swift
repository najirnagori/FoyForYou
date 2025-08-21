//
//  Validator.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import Foundation


protocol ValidatorProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}

class Validator: ValidatorProtocol {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx =
        "(?:[A-Z0-9a-z._%+-]+)@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,64}"
        
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            .evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx =
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        
        return NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            .evaluate(with: password)
    }
}
