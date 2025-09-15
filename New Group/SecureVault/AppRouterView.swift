//
//  AppRouterView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import SwiftUI

struct AppRouterView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        Group {
            if !authManager.hasMasterPassword {
                MasterPasswordSetupView(authManager: authManager)
            }
            else if authManager.showingLogin || !authManager.isAuthenticated {
                LoginView(authManager: authManager)
            }
            else {
                MainAppView(authManager: authManager)
            }
        }
    }
}

#Preview {
    AppRouterView()
}
