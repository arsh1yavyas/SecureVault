//
//  KeychainManager.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: Constants
    
    private let service = "com.secureaVault.passwords"
    
    // MARK: Master Password Management
    
    func saveMasterPassword(_ password: String) -> Bool{
        let passwordData = password.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "masterPassword",
            kSecValueData as String: passwordData
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func verifyMasterPassword(_ inputPassword: String) -> Bool{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "masterPassword",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let retrievedPassword = String(data: retrievedData, encoding: .utf8) {
                return retrievedPassword == inputPassword
            }
        }
        
        return false
    }
    
    func masterPasswordExists() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "masterPassword",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: false
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func savePasswordEntry(websiteName: String, username: String, password: String) -> Bool {
        let entry = PasswordEntry(
            websiteName: websiteName,
            username: username,
            password: password
        )
        
        guard let entryData = try? JSONEncoder().encode(entry) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: entry.id.uuidString,
            kSecValueData as String: entryData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getAllPasswordEntries() -> [PasswordEntry] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else {
            return []
        }
        
        var entries: [PasswordEntry] = []
        
        if let items = dataTypeRef as? [[String: Any]] {
            for item in items {
                if let account = item[kSecAttrAccount as String] as? String,
                account != "masterPassword",
                let data = item[kSecValueData as String] as? Data,
                let entry = try? JSONDecoder().decode(PasswordEntry.self, from: data) {
                    entries.append(entry)
                }
            }
        }
        
        return entries.sorted { $0.websiteName.lowercased() < $1.websiteName.lowercased() }
    }
    
    func deletePasswordEntry(withId id: UUID) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: id.uuidString
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    func deleteAllPasswordEntries() -> Bool {
        let entries = getAllPasswordEntries()
        var allDeleted = true
        
        for entry in entries {
            if !deletePasswordEntry(withId: entry.id) {
                allDeleted = false
            }
        }
        
        return allDeleted
    }
}
