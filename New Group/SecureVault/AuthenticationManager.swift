//
//  AuthenticationManager.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import Foundation
import SwiftUI

class AuthenticationManager : ObservableObject {
    @Published var isAuthenticated = false
    @Published var hasMasterPassword = false
    @Published var showingLogin = false
    
    init() {
        checkMasterPasswordExists()
    }
    
    private func checkMasterPasswordExists() {
        hasMasterPassword = false
    }
    
    func createMasterPassword(_ password: String) {
        print("Master password created: \(password)")
        
        hasMasterPassword = true
        isAuthenticated = true
    }
    
    func login(with password: String) -> Bool {
        print("Login attempt with password: \(password)")
        isAuthenticated = true
        showingLogin = false
        return true
    }
    
    func logout() {
        isAuthenticated = false
        showingLogin = false
    }
    
    func requireLogin() {
        showingLogin = true
        isAuthenticated = false
    }
}
