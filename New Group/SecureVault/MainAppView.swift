//
//  MainAppView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct MainAppView: View {
    @ObservedObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Welcome to SecureVault!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("You are now authenticated and can access your saved passwords.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Logout") {
                    authManager.logout()
                }
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("SecureVault")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
