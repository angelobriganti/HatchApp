//
//  OnboardingSlideView.swift
//  AppTimer
//
//  Created by (Il tuo nome) on 07/11/25.
//

import SwiftUI

struct OnboardingSlideView: View {
    
    var speechText: String
    
    var body: some View {
        
        // ZStack per contenere il testo animato.
        ZStack {
            Text(speechText)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5) // Leggero padding
            
                // L'animazione è applicata SOLO al testo.
                .id(speechText)
                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
        }
        // Il frame fisso (e la centratura) è applicato alla ZStack.
        .frame(height: 100)
        
        // Lo sfondo (la nuvoletta) è applicato alla ZStack
        .padding(25)
        .background(.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 5, y: 3)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.white, .indigo],
            startPoint: .top,
            endPoint: .bottom)
        .ignoresSafeArea()
        
        OnboardingSlideView(speechText: "Testo di prova.")
    }
}
