//
//  PasswordGenerator.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/14/25.
//

import Foundation

struct PasswordOptions {
    var includeUppercase: Bool = true
    var includeLowercase: Bool = true
    var includeNumbers: Bool = true
    var includeSymbols: Bool = true
    var length: Int = 12
    
    var hasValidOptions: Bool {
        return includeUppercase || includeLowercase || includeNumbers || includeSymbols
    }
}

class PasswordGenerator {
    private let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    private let upercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private let numbers = "0123456789"
    private let specialCharacters = "!@#$%^&*()_+-=[]{};:,.<>?"
    
    init() {
        // todo
    }
    
    func generatePassword(with options: PasswordOptions) -> String {
        guard options.hasValidOptions && options.length > 0 else {
            return ""
        }
        
        var characterPool = ""
        
        if options.includeLowercase {
            characterPool += lowercaseLetters
        }
        
        if options.includeUppercase {
            characterPool += upercaseLetters
        }
        
        if options.includeNumbers {
            characterPool += numbers
        }
        
        if options.includeSymbols {
            characterPool += specialCharacters
        }
        
        var password = ""
        
        for _ in 0..<options.length {
            let randomIndex = Int.random(in: 0..<characterPool.count)
            let randomCharacter = characterPool[characterPool.index(characterPool.startIndex, offsetBy: randomIndex)]
            password.append(randomCharacter)
        }
        
        return password
    }
    
    enum PasswordStrength: String, CaseIterable {
        case weak = "Weak"
        case medium = "Medium"
        case strong = "Strong"
    }
    
    func evaluatePassswordStrength(_ password: String) -> PasswordStrength {
        var score = 0
        
        if password.count >= 8 {
            score += 1
        }
        if password.count >= 12 {
            score += 1
        }
        
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: lowercaseLetters)) != nil {
            score += 1
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: upercaseLetters)) != nil {
            score += 1
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: numbers)) != nil {
            score += 1
        }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: specialCharacters)) != nil {
            score += 1
        }
        
        switch score {
        case 0...2:
            return .weak
        case 3...4:
            return .medium
        default:
            return .strong
        }
    }
    
    // MARK: Convenience Functions
    
    func generateStrongPassword(length: Int = 16) -> String {
        let options = PasswordOptions(
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: true,
            length: length
        )
        return generatePassword(with: options)
    }
    
    func generateSimplePassword(length: Int = 12) -> String {
        let options = PasswordOptions(
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: false,
            length: length
        )
        return generatePassword(with: options)
    }
    
    func generatePIN(length: Int = 4) -> String {
        let options = PasswordOptions(
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: true,
            includeSymbols: false,
            length: length
        )
        return generatePassword(with: options)
    }
}
