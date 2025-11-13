//
//  OnboardingView.swift
//  AppTimer
//
//  Created by (Il tuo nome) on 07/11/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var currentTab = 0
    
    let speechTexts = [
        // Slide 1: Intro
        "Hi! I'm Hatchy, the Focus Dino! I'm here to help you study.",
        
        // Slide 2: Problema
        "I know, studying is tough... especially when your phone keeps distracting you with notifications and messages!",
        
        // Slide 3: Soluzione + Ricompensa
        "Let's use this timer to focus together! While you study, you'll help my eggs hatch and build your collection.",
        
        // Slide 4: Avvertimento + Via
        "Are you ready to start?"
    ]

    var body: some View {
        
        ZStack {
            // 1. Sfondo
            LinearGradient(
                colors: [.white, .indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // 2. La Mascotte (centrata)
            Image("dino1")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .padding(.top, 100)
            
            // 3. Contenuto Superiore (Nuvoletta)
            VStack {
                OnboardingSlideView(speechText: speechTexts[currentTab])
                Spacer()
            }
            .padding(.top, 50)

            // 4. Contenuto Inferiore (Pulsante e Puntini Animati)
            VStack(spacing: 20) {
                Spacer() // Spinge tutto in basso

                // Contenitore per l'animazione
                ZStack {
                    
                    if currentTab == speechTexts.count - 1 {
                        // ULTIMA SLIDE: Pulsante "Start!"
                        Button(action: {
                            // Imposta semplicemente il valore
                            self.hasCompletedOnboarding = true
                            
                        }) {
                            Text("Start!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white) // Testo bianco
                                .padding(.vertical, 12)
                                .padding(.horizontal, 90)
                                .background(
                                    // Forma normale
                                    Capsule()
                                        .fill(.indigo)
                                )
                        }
                        .transition(.opacity.animation(.easeInOut.delay(0.1)))
                        
                    } else {
                        // ALTRE SLIDE: "Bubble Dots"
                        HStack(spacing: 12) {
                            ForEach(0..<speechTexts.count, id: \.self) { index in
                                if currentTab == index {
                                    let swipeText = "Swipe >"
                                    
                                    // Puntino ATTIVO
                                    Text(swipeText)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.indigo) // Testo indaco
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            // Forma normale
                                            Capsule()
                                                .fill(Color.white)
                                        )
                                        .transition(.opacity.animation(.easeInOut))
                                } else {
                                    // Il puntino INATTIVO
                                    Circle()
                                        .fill(Color.white.opacity(0.5))
                                        .frame(width: 10, height: 10)
                                        .transition(.opacity.combined(with: .scale))
                                }
                            }
                        }
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentTab)
                .frame(height: 80) // Altezza fissa per coerenza
            }
            .padding(.bottom, 30) // Spazio dal fondo
        }
        // Gesto di Swipe
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        if currentTab < speechTexts.count - 1 {
                            currentTab += 1
                        }
                    }
                }
        )
        // Feedback Aptico
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.7), trigger: currentTab)
    }
}

#Preview {
    OnboardingView()
}
