//
//  AlertModifier.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct CustomAlertModifier1: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert("Alert", isPresented: $isPresented) {
                Button("OK", role: .cancel) {
                    action?()
                }
            } message: {
                Text(message)
            }
    }
}

struct CustomAlertModifier2: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let action: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .alert("Alert", isPresented: $isPresented) {
                
                Button("cancle", role: .cancel) {}
                
                Button("Delete", role: .destructive) {
                    action()
                }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, message: String, action: (() -> Void)? = nil) -> some View {
        self.modifier(CustomAlertModifier1(isPresented: isPresented, message: message, action: action))
    }
    
    func customAlert2(isPresented: Binding<Bool>, message: String, action: (() -> Void)?) -> some View {
        self.modifier(CustomAlertModifier2(isPresented: isPresented, message: message, action: action ?? {}))
    }
}

