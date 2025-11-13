//
//  CollectionView.swift
//  AppTimer
//
//  Created by AFP Student 56 on 04/11/25.
//

import SwiftUI

let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible())
]

struct CollectionView: View {
    
    @State private var selectedCreature: Creature? = nil
    
    var myData = sharedData
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                ZStack {
                    LinearGradient(
                        colors: [.white, .indigo],
                        startPoint: .top,
                        endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(myData.creatures) { creature in
                                
                                // --- MODIFICA 1: Wrapper VStack ---
                                // Questo VStack ora contiene sia l'immagine
                                // che il testo, rendendo tutto cliccabile.
                                VStack {
                                    VStack { // VStack originale dell'immagine
                                        if creature.isUnlocked {
                                            Image(creature.image)
                                                .resizable()
                                                .frame(width: 200, height: 200)
                                        } else {
                                            ZStack {
                                                Image(creature.eggImage)
                                                    .resizable()
                                                    .frame(width: 120, height: 150)
                                                    .opacity(0.7)
                                                
                                                Image(systemName: "lock.fill")
                                                    .font(.title)
                                            }
                                        }
                                    }
                                    
                                    VStack { // VStack originale del testo
                                        Text(creature.name)
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title2)
                                        
                                        if creature.isUnlocked {
                                            if let unlockDate = creature.unlockDate {
                                                Text("Hatched: \(unlockDate.formatted(date: .abbreviated, time: .omitted))")
                                                    .font(.caption)
                                                    .foregroundColor(.primary)
                                            }
                                            if creature.cycles > 0 {
                                                Text("at \(creature.cycles) cycles")
                                                    .font(.caption)
                                                    .foregroundColor(.primary)
                                            }
                                        } else {
                                            let remaining = myData.remainingCycles(for: creature)
                                            Text("\(remaining) cycles left").bold()
                                            Text("(" + String(convertCycle(cycle: remaining)) + " hour)")
                                        }
                                    }
                                }
                                // --- MODIFICA 2: .onTapGesture spostato ---
                                .onTapGesture {
                                    if creature.isUnlocked {
                                        withAnimation(.spring()) {
                                            self.selectedCreature = creature
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Collection")
            }
            
            .overlay {
                if let creature = selectedCreature {
                    CreatureDetailPopup(creature: creature) {
                        // Azione di chiusura
                        withAnimation(.spring()) {
                            selectedCreature = nil
                        }
                    }
                    // --- MODIFICA 3: Transizione rimossa ---
                    // L'animazione ora è gestita dal popup
                }
            }
        }
    }
}

func convertCycle(cycle: Int) -> Double {
    if cycle == 1 {
        return 0.5
    }
    else {
        return Double((cycle * 30) / 60)
    }
}

#Preview {
    CollectionView()
}
