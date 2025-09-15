//
//  LoginView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var enteredPassword = ""
    @State private var showError = false
    @State private var isLoading = false
    
    private func attemptLogin() {
        showError = false
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let success = authManager.login(with: enteredPassword)
            
            isLoading = false
            
            if success {
                enteredPassword = ""
            }
            else {
                showError = true
                enteredPassword = ""
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("SecureVault")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Enter your master password to continue")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Master Password")
                    .font(.headline)
                
                SecureField("Enter your master password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)
                    .onSubmit {
                        attemptLogin()
                    }
            }
            
            if showError {
                Text("Incorrect password. Please try again.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: attemptLogin) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                else {
                    Text("Unlock")
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(enteredPassword.isEmpty ? Color.green : Color.blue)
            .cornerRadius(10)
            .disabled(enteredPassword.isEmpty || isLoading)
            .padding(.top, 10)
        }
        .padding()
    }
}
