//
//  PasswordGeneratorView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/14/25.
//

import SwiftUI

struct PasswordGeneratorView: View {
    @State private var passwordLength: Double = 12
    @State private var includeUppercase: Bool = true
    @State private var includeLowercase: Bool = true
    @State private var includeNumbers: Bool = true
    @State private var includeSymbols: Bool = false
    @State private var generatedPassword = ""
    
    private var hasValidCharacterTypes : Bool {
        return includeUppercase || includeLowercase || includeNumbers || includeSymbols
    }
    
    private func generatePassword() {
        guard hasValidCharacterTypes else {
            return
        }
        
        var characterSet = ""
        
        if includeUppercase {
            characterSet.append("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
        if includeLowercase {
            characterSet.append("abcdefghijklmnopqrstuvwxyz")
        }
        if includeNumbers {
            characterSet.append("0123456789")
        }
        if includeSymbols {
            characterSet.append("!@#$%^&*()_+-=[]{}|;:,.<>?")
        }
        
        generatedPassword = String((0..<Int(passwordLength)).map {_ in characterSet.randomElement()!})
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = generatedPassword
        print("Password copied to clipboard!")
    }
    
    private func useThisPassword() {
        print("Using password: \(generatedPassword)")
        copyToClipboard( )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Password Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Customize your password settings below")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Password Length")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(Int(passwordLength))")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $passwordLength, in:  4...50, step: 1)
                        .accentColor(.blue)
                    
                    HStack {
                        Text("4")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("50")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Character Types")
                        .font(.headline)
                    
                    Toggle("Include Uppercase Letters (A-Z)", isOn: $includeUppercase)
                        .toggleStyle(.switch)
                    Toggle("Include Lowercase Letters (a-z)", isOn: $includeLowercase)
                        .toggleStyle(.switch)
                    Toggle("Include Numbers (0-9)", isOn: $includeNumbers)
                        .toggleStyle(.switch)
                    Toggle("Include Symbols (!@#$%)", isOn: $includeSymbols)
                        .toggleStyle(.switch)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Generated Password")
                        .font(.headline)
                    
                    Text(generatedPassword.isEmpty ? "Tap 'Generate' to create a password" : generatedPassword)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .textSelection(.enabled)
                }
                
                Button(action: generatePassword) {
                    Text("Generate")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(hasValidCharacterTypes ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!hasValidCharacterTypes)
                .padding(.top, 10)
                
                if !generatedPassword.isEmpty {
                    HStack(spacing: 15) {
                        Button(action: copyToClipboard) {
                            Text("Copy to Clipboard")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Button(action: useThisPassword) {
                            Text("Use This Password")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
