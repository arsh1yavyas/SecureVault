//
//  LockScreenView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/14/25.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var autoLockManager: AutoLockManager
    @State private var enteredPassword = ""
    @State private var showError: Bool = false
    @State private var errorMessage = ""
    
    private func unlockApp() {
        showError = false
        errorMessage = ""
        
        guard !enteredPassword.isEmpty else {
            showError = true
            errorMessage = "Please enter your master password"
            return
        }
        
        if KeychainManager.shared.verifyMasterPassword(enteredPassword) {
            autoLockManager.unlockApp()
            enteredPassword = ""
        }
        else {
            showError = true
            errorMessage = "Incorrect master password"
            enteredPassword = ""
        }
        
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("SecureVault Locked")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Enter your master password to unlock")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Master Password")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    SecureField("Enter master password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            unlockApp()
                        }
                }
                .padding(.top, 20)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: unlockApp) {
                    Text("Unlock")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(enteredPassword.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(enteredPassword.isEmpty)
                .padding(.top, 10)
            }
            .padding()
        }
    }
}
