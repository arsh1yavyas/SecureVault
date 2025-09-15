//
//  PasswordEntry.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import Foundation

struct PasswordEntry: Identifiable, Codable {
    let id: UUID
    let websiteName: String
    let username: String
    let password: String
    let createdDate: Date
    
    init(websiteName: String, username: String, password: String) {
        self.id = UUID()
        self.websiteName = websiteName
        self.username = username
        self.password = password
        self.createdDate = Date()
    }

}

extension PasswordEntry {
    static let sampleData: [PasswordEntry] = [
        PasswordEntry(websiteName: "Google", username: "user@gmail.com", password: "mySecurePassword123"),
        PasswordEntry(websiteName: "Facebook", username: "johndoe", password: "password456"),
        PasswordEntry(websiteName: "Netflix", username: "user@gmail.com", password: "streamingPass789")
    ]
}
