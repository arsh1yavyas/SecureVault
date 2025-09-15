//
//  AddPasswordView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct AddPasswordView: View {
    @State private var websiteName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showSuccessMessage = false
    @State private var showPassword = false
    @Environment(\.presentationMode) var presentationMode
    
    private var isFormValid: Bool {
        let nonEmptyPassword: Bool = !password.isEmpty
        let hasWebsiteAndUsername: Bool = !websiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return nonEmptyPassword && hasWebsiteAndUsername
    }
    
    private var validationMessage: String {
        if websiteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please enter a website or app name"
        }
        else if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please enter a username or email"
        }
        else if password.isEmpty {
            return "Please enter a password"
        }
        return ""
    }
    
    private func savePassword() {
        guard isFormValid else {
            return
        }
        
        print("Saving password entry:")
        print("Website: \(websiteName)")
        print("Username: \(username)")
        print("Password: \(password)")
        
        let success = KeychainManager.shared.savePasswordEntry (
            websiteName: websiteName,
            username: username,
            password: password
        )
        
        if success {
            print("Successfully saved to Keychain!")
            showSuccessMessage = true
            
            websiteName = ""
            username = ""
            password = ""
            showPassword = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presentationMode.wrappedValue.dismiss()
                showSuccessMessage = false
            }
        }
        else {
            print("Failed to save to Keychain")
        }
        
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                
            Text("Store your login credentials securely")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Website/App Name")
                    .font(.headline)
                    .foregroundColor(.primary)
                    
                TextField("Enter website or app name", text: $websiteName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Username/Email")
                    .font(.headline)
                    .foregroundColor(.primary)
                    
                TextField("Enter username or email", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .textContentType(.username)
            }
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.headline)
                    .foregroundColor(.primary)
                    
                HStack {
                    if showPassword {
                        TextField("Enter password", text: $password)
                    }
                    else {
                        SecureField("Enter password", text: $password)
                    }
                        
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)
            }
                
            if !isFormValid && (!websiteName.isEmpty || !username.isEmpty || !password.isEmpty) {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
                
            if showSuccessMessage {
                Text("Password saved successfully!")
                    .foregroundColor(.green)
                    .font(.caption)
                    .padding(.top, 5)
            }
                
            Button(action: savePassword) {
                Text("Save Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
            .padding(.top, 30)
                
            Spacer()
        }
        .padding()
        .navigationTitle("New Entry")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ADD PASSWORD VIEW LOADED")
        }
    }
}
