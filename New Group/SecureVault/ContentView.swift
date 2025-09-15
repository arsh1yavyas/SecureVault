//
//  ContentView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/12/25.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isSetupComplete = false
    @State private var isUnlocked = false
    
    var body: some View {
//        NavigationView {
//            if !isSetupComplete {
//                MasterPasswordSetupView(isSetupComplete: $isSetupComplete)
//            }
//            else if !isUnlocked {
//                UnlockView(isUnlocked: $isUnlocked)
//            }
//            else {
//                MainPasswordView()
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .onAppear {
//            checkSetupStatus()
//        }
//    }
//    
//    // MARK: Methods
//    
//    private func checkSetupStatus() {
//        print("Checking setup status...")
//    }
        AppRouterView()
}

// MARK: Unlock View

struct UnlockView: View {
    @Binding var isUnlocked: Bool
    @State private var enteredPassword = ""
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("SecureVault")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enter your master password")
                .font(.headline)
                .foregroundColor(.secondary)
            
            SecureField("Master password", text: $enteredPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)
            
            if showError {
                Text("Incorrect password")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Unlock") {
                if !enteredPassword.isEmpty {
                    isUnlocked = true
                }
                else {
                    showError = true
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(enteredPassword.isEmpty)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: Main Password Manager View

struct MainPasswordView: View {
    var body: some View {
        VStack {
            Text("Welcome to SecureVault!")
                .font(.title)
                .fontWeight(.bold)
            Text("Your passwords will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
            List {
                Text("No passwords yet")
                    .foregroundColor(.secondary)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("SecureVault")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    // TODO
                }
            }
        }
    }
}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
