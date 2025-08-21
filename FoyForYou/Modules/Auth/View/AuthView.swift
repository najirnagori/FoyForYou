//
//  AuthView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 19/08/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var appState: UIState
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            authPicker
            userImage
            textFields
            button
            Spacer()
        }
        .customAlert(
            isPresented: $authViewModel.showAlert,
            message: authViewModel.errorMessage ?? ""
        )
    }
}

#Preview {
    AuthView()
}


extension AuthView {
    private var authPicker: some View {
        Picker(
            selection: $authViewModel.isLoginMode,
            label: Text("Picker here"))
        {
            Text("Login").tag(true)
            Text("Create Account").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var userImage: some View {
        if !authViewModel.isLoginMode {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.blue)
        } else {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
        }
    }
    
    private var textFields: some View {
        Group {
            TextField(
                "Email",
                text: $authViewModel.email
            )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $authViewModel.password)
            
            if !authViewModel.isLoginMode {
                SecureField("Confirm Password", text: $authViewModel.confirmPassword)
            }
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.primary.opacity(0.1), radius: 2)
        .padding(.horizontal)
    }
    
    private var button: some View {
        Button {
            if authViewModel.loginSignupAction() {
                withAnimation {
                    appState.changeTab(to: .tab)
                }
            }
        } label: {
            buttonLable
        }
    }
    
    private var buttonLable: some View {
        HStack {
            Spacer()
            Text(authViewModel.isLoginMode ? "Log In" : "Create Account")
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .font(.system(size: 16, weight: .semibold))
            Spacer()
        }
        .background(Color.blue)
        .cornerRadius(8)
        .padding()
    }
}
