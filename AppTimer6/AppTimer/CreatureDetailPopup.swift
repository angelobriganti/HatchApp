//
//  CreatureDetailPopup.swift
//  AppTimer
//
//  Created by (Il tuo nome) on 11/11/25.
//

import SwiftUI

struct CreatureDetailPopup: View {
    let creature: Creature
    let onDismiss: () -> Void
    
    // --- MODIFICA 1: Stato per l'animazione ---
    @State private var hasAppeared = false
    
    // Funzione helper per ottenere le descrizioni
    private func getDescription(for name: String) -> String {
        switch name {
        case "Hatchy":
            return "A gentle giant and the first to join your collection, Hatchy the Brachiosaurus is a symbol of calm focus. Loves munching on the tallest leaves."
        case "Topos":
            return "Sturdy and reliable, Topos the Triceratops is known for its three horns and friendly nature. A perfect companion for tough study sessions."
        case "Steggy":
            return "With iconic plates along its back, Steggy the Stegosaurus is a unique and creative creature. A reminder that every problem has a unique solution."
        case "Zalco":
            return "Zalco the Pterodactyl soars above the rest. Unlocking this creature shows your focus is reaching new heights!"
        case "Bloragon":
            return "A mysterious and powerful marine creature, Bloragon rules the deep. Unlocked by only the most dedicated and persistent learners."
        case "Nimbusar":
            return "Fast, intelligent, and agile. Nimbusar the Velociraptor represents quick thinking and sharp focus. A truly impressive achievement."
        case "Tharnis":
            return "The mighty T-Rex! Tharnis is the king of the collection, a testament to incredible long-term dedication and legendary focus. Congratulations!"
        default:
            return "A mysterious and rare creature, not much is known about it... yet."
        }
    }

    var body: some View {
        ZStack {
            
            // Layer opaco scuro (come in UnlockPopup)
            Color.black
                // --- MODIFICA 2: Opacità animata ---
                .opacity(hasAppeared ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss() // Chiudi se clicchi fuori
                }

            // Box bianco (come in UnlockPopup)
            VStack(spacing: 15) {
                
                // Immagine
                Image(creature.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                // Nome
                Text(creature.name)
                    .font(.largeTitle)
                    .bold()
                
                // Descrizione
                Text(getDescription(for: creature.name))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Pulsante Chiudi
                Button {
                    onDismiss()
                } label: {
                    Text("Close")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 50)
                        .background(Color.indigo)
                        .cornerRadius(40)
                }
                .padding(.top)
            }
            .padding()
            .frame(width: 340) // Leggermente più largo per il testo
            .background(.white)
            .cornerRadius(40)
            .shadow(radius: 15)
            // --- MODIFICA 3: Animazione di scala e opacità ---
            .scaleEffect(hasAppeared ? 1 : 0.8)
            .opacity(hasAppeared ? 1 : 0)
        }
        // --- MODIFICA 4: Trigger dell'animazione ---
        .onAppear {
            withAnimation(.spring()) {
                hasAppeared = true
            }
        }
    }
}
