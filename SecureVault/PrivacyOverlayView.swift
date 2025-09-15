//
//  PrivacyOverlayView.swift
//  SecureVault
//
//  Created by Arshiya Vyas on 9/14/25.
//

import SwiftUI

struct PrivacyOverlayView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text("SecureVault")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Tap to unlock")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
}
