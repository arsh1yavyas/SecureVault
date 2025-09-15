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
    @State private var searchText = ""
    @StateObject private var autoLockManager = AutoLockManager()
    @State private var isAppInBackground = false
    @State private var showPrivacyOverlay = true
    @State private var isAuthenticated = false
    @State private var passwords: [PasswordEntry] = []
    
    private var filteredPasswords: [PasswordEntry] {
        if searchText.isEmpty {
            return passwords
        }
        else {
            return passwords.filter {
                password in password.websiteName.localizedCaseInsensitiveContains(searchText) || password.username.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func dismissPrivacyOverlay() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showPrivacyOverlay = false
            isAuthenticated = true
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                PasswordListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if autoLockManager.isLocked {
                LockScreenView(autoLockManager: autoLockManager)
                    .transition(.opacity)
            }
            
            if showPrivacyOverlay {
                PrivacyOverlayView()
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture {
                        dismissPrivacyOverlay()
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {_ in
            autoLockManager.pauseTimer()
            isAppInBackground = true
            showPrivacyOverlay = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) {_ in
            isAppInBackground = false
            if autoLockManager.isLocked {
                return
            }
            else {
                autoLockManager.lockAppManually()
            }
        }
        .onAppear {
            passwords = KeychainManager.shared.getAllPasswordEntries()
        }
    }
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

//// MARK: Main Password Manager View
//
//struct MainPasswordView: View {
//    @Binding var passwords: [PasswordEntry]
//    @Binding var searchText: String
//    
//    private var filteredPasswords: [PasswordEntry] {
//        if searchText.isEmpty {
//            return passwords
//        } else {
//            return passwords.filter { password in password.websiteName.localizedCaseInsensitiveContains(searchText) || password.username.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//    
//}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
