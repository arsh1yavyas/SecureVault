//
//  AuthenticationView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject private var biometricManager = BiometricAuthManager()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false
    @State private var showMasterPasswordField = false
    @State private var masterPasswordInput = ""
    
    private var biometricIcon: String {
        switch biometricManager.getBiometricType() {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .opticID:
            return "opticid"
        case .none:
            return "lock"
        }
    }
    
    private var biometricButtonText: String {
        switch biometricManager.getBiometricType() {
        case .faceID:
            return "Use Face ID"
        case .touchID:
            return "Use Touch ID"
        case .opticID:
            return "Use Optic ID"
        case .none:
            return "Unlock"
        }
    }
    
    private func authenticateWithBiometrics() {
        Task {
            do {
                let success = try await biometricManager.authenticateWithBiometrics()
                if success {
                    await MainActor.run {
                        isAuthenticated = true
                    }
                }
            }
            catch {
                await MainActor.run {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
    
    private func authenticateWithMasterPassword() {
        guard !masterPasswordInput.isEmpty else {
            alertMessage = "Please enter your master password"
            showingAlert = true
            return
        }
        
        if masterPasswordInput.count >= 8 {
            isAuthenticated = true
            masterPasswordInput = ""
        }
        else {
            alertMessage = "Invalid master password"
            showingAlert = true
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "lock.shield")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("SecureVault")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your passwords are protected")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if biometricManager.isBiometricAuthenticationAvailable() {
                Button(action: authenticateWithBiometrics) {
                    HStack {
                        Image(systemName: biometricIcon)
                            .font(.title2)
                        Text(biometricButtonText)
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            else {
                Text("Biometric authentication not available")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Button("Use Master Password Instead") {
                showMasterPasswordField = true
            }
            .foregroundColor(.blue)
            .padding(.top, 10)
            
            if showMasterPasswordField {
                VStack(spacing: 15) {
                    SecureField("Enter master password", text: $masterPasswordInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                    
                    Button("Unlock") {
                        authenticateWithMasterPassword()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(masterPasswordInput.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .disabled(masterPasswordInput.isEmpty)
                }
                .padding(.top, 20)
                .alert("Authentication Error", isPresented: $showingAlert) {
                        Button("OK") {
                            // Alert will dismiss automatically
                        }
                }
                message: {
                    Text(alertMessage)
                }
            }
        }
        .padding()
    }
    
}

#Preview {
    AuthenticationView()
}
