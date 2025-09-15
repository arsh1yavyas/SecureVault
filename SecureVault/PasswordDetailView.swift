//
//  PasswordDetailView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct PasswordDetailView: View {
    let websiteName: String
    let username: String
    let password: String
    
    @State private var isPasswordVisible: Bool = false
    @State private var showCopyMessage: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text(websiteName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Username")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(username)
                            .font(.body)
                            .textSelection(.enabled)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = username
                        showCopyMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopyMessage = false
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            if isPasswordVisible {
                                Text(password)
                                    .font(.system(.body, design: .monospaced))
                                    .textSelection(.enabled)
                            }
                            else {
                                Text(String(repeating: "•", count: password.count))
                                    .font(.body)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = password
                        showCopyMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showCopyMessage = false
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            if showCopyMessage {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text("Copied to clipboard!")
                        .foregroundColor(.green)
                        .font(.caption)
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: showCopyMessage)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Password Details")
    }
}

// MARK: Preview

struct PasswordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordDetailView(
                websiteName: "Gmail",
                username: "john@gmail.com",
                password: "mySecurePassword123"
            )
        }
    }
}
