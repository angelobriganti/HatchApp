//
//  AppTimerApp.swift
//  AppTimer
//
//  Created by AFP Student 56 on 03/11/25.
//

import SwiftUI

@main
struct AppTimerApp: App {
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            
            // ZStack per la transizione "fade"
            ZStack {
                if hasCompletedOnboarding {
                    ContentView()
                        // La ContentView appare in dissolvenza
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                } else {
                    OnboardingView()
                        // L'Onboarding scompare in dissolvenza
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
            }
            // Applica l'animazione al cambio di 'hasCompletedOnboarding'
            .animation(.default, value: hasCompletedOnboarding)
        }
    }
}
