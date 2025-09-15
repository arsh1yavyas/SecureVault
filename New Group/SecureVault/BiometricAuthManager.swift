//
//  BiometricAuthManager.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/13/25.
//

import LocalAuthentication
import Foundation

class BiometricAuthManager : ObservableObject {
    private let context = LAContext()
    
    enum BiometricType {
        case none
        case touchID
        case faceID
        case opticID
    }
    
    enum AuthenticationError: Error, LocalizedError {
        case biometricNotAvailable
        case biometricNotEnrolled
        case authenticationFailed
        
        var errorDescription: String? {
            switch self {
            case .biometricNotAvailable:
                return "Biometric authentication is not available on this device"
            case .biometricNotEnrolled:
                return "No biometric authentication is set up on this device"
            case .authenticationFailed:
                return "Authentication failed"
            }
        }
    }
    
    func getBiometricType() -> BiometricType {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            return .none
        }
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            return .opticID
        @unknown default:
            return .faceID
        }
    }
    
    func isBiometricAuthenticationAvailable() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authenticateWithBiometrics() async throws -> Bool {
        guard isBiometricAuthenticationAvailable() else {
            throw AuthenticationError.biometricNotAvailable
        }
        
        let reason = "Unlock your password vault"
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return success
        }
        catch LAError.biometryNotEnrolled {
            throw AuthenticationError.biometricNotEnrolled
        }
        catch LAError.authenticationFailed {
            throw AuthenticationError.authenticationFailed
        }
        catch {
            throw AuthenticationError.authenticationFailed
        }
    }
}
