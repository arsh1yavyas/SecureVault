//
//  MasterPasswordSetupView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/12/25.
//

import SwiftUI

struct MasterPasswordSetupView: View {
    @State private var masterPassword = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @Binding var isSetupComplete: Bool
    @ObservedObject var authManager: AuthenticationManager
    
    // MARK: Computed Properties
    
    private var isPasswordValid: Bool {
        return masterPassword.count >= 8 && !masterPassword.isEmpty
    }
    private var passwordsMatch: Bool {
        return masterPassword == confirmPassword && !confirmPassword.isEmpty
    }
    private var canCreatePassword: Bool {
        return isPasswordValid && passwordsMatch
    }
    
    private func createMasterPassword() {
        showError = false
        errorMessage = ""
        
        guard canCreatePassword else {
            showError = true
            errorMessage = "Please check your password requirements"
            return
        }
    
        authManager.createMasterPassword(masterPassword)
        masterPassword = ""
        confirmPassword = ""
        isSetupComplete = true
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: Header
            
            VStack(spacing: 8) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("Create Master Password")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Your master password will be used to unlock your saved passwords")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            // MARK: assword Fields
            
            VStack(alignment: .leading, spacing: 16) {
                SecureField("Enter your master password", text: $masterPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
                SecureField("Re-enter your master password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
            }
            
            // MARK: Password Requirements
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Password Requirements: ")
                    .font(.caption)
                    .fontWeight(.medium)
                HStack {
                    Image(systemName: masterPassword.count >= 8 ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(masterPassword.count >= 8 ? .green : .secondary)
                    Text("At least 8 characters")
                        .font(.caption)
                }
                HStack {
                    Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(passwordsMatch ? .green : .secondary)
                    Text("Passwords match")
                        .font(.caption)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showError{
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
            
            Button("Create Master Password") {
                createMasterPassword()
            }
            .disabled(!canCreatePassword)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
            .background(canCreatePassword ? Color.blue : Color.gray)
            
            Spacer()
            
        }
        .padding()
        .navigationBarHidden(true)
    }
}

// MARK: Preview

struct MasterPasswordSetupView_Previews: PreviewProvider {
    static var previews: some View {
        MasterPasswordSetupView(isSetupComplete: .constant(false))
    }
}
