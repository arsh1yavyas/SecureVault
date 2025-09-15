//
//  AutoLockManager.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/14/25.
//

import Foundation
import SwiftUI

class AutoLockManager: ObservableObject {
    @Published var isLocked = false
    
    private var inactivityTimer: Timer?
    private let lockTimeInterval: TimeInterval = 300
    
    init() {
        startInactivityTimer()
    }
    
    deinit {
        inactivityTimer?.invalidate()
    }
    
    private func startInactivityTimer() {
        inactivityTimer?.invalidate()
        
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: lockTimeInterval, repeats: false) {
            [weak self] _ in DispatchQueue.main.async {
                self?.lockApp()
            }
        }
    }
    
    func resetInactivityTimer() {
        startInactivityTimer()
    }
    
    private func lockApp() {
        isLocked = true
        inactivityTimer?.invalidate()
        print("App automatically locked due to inactivity")
    }
    
    func lockAppManually() {
        isLocked = true
        inactivityTimer?.invalidate()
        print("App locked manually")
    }
    
    func unlockApp() {
        isLocked = false
        startInactivityTimer()
        print("App unlocked - inactivity timer restarted")
    }
    
    func pauseTimer() {
        inactivityTimer?.invalidate()
    }
    
    func resumeTimer() {
        if !isLocked {
            startInactivityTimer()
        }
    }
}
