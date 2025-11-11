//
//  Data.swift
//  AppTimer
//
//  Created by AFP Student 56 on 04/11/25.
//

import SwiftUI

@Observable
class SharedData {

    var totalCyclesCompleted: Int = 0

    var creatures = [
        Creature(name: "Hatchy", image: "dino1", eggImage: "egg", cycles: 0, isUnlocked: true),     //brachiosaurus
        Creature(name: "Topos", image: "dino2", eggImage: "egg", cycles: 1, isUnlocked: false),     // triceratops
        Creature(name: "Steggy", image: "dino3", eggImage: "egg", cycles: 5, isUnlocked: false),    // stegosaurus
        Creature(name: "Zalco", image: "dino4", eggImage: "egg", cycles: 10, isUnlocked: false),    // pterodactyl
        Creature(name: "Bloragon", image: "dino1", eggImage: "egg", cycles: 20, isUnlocked: false), // something marine
        Creature(name: "Nimbusar", image: "dino1", eggImage: "egg", cycles: 30, isUnlocked: false), // velociraptor
        Creature(name: "Tharnis", image: "dino1", eggImage: "egg", cycles: 50, isUnlocked: false)   // t-rex
    ]

    init() {
        self.loadProgress()
    }

    // Aggiorna le creature e restituisce l’eventuale nuova sbloccata
    func updateCreatures() -> Creature? {
        var unlockedCreature: Creature? = nil
        for i in 0..<creatures.count {
            if totalCyclesCompleted >= creatures[i].cycles && !creatures[i].isUnlocked {
                creatures[i].isUnlocked = true
                creatures[i].unlockDate = Date() // <-- MODIFICA: Imposta la data di sblocco
                unlockedCreature = creatures[i]
            }
        }
        self.saveProgress()
        return unlockedCreature
    }

    func remainingCycles(for creature: Creature) -> Int {
        max(creature.cycles - totalCyclesCompleted, 0)
    }

    // Funzione di salvataggio su UserDefaults
    func saveProgress() {
        let defaults = UserDefaults.standard
        defaults.set(self.totalCyclesCompleted, forKey: "totalCyclesCompleted")
        
        // Salva i nomi (come prima)
        let unlocked = creatures.filter { $0.isUnlocked }.map { $0.name }
        defaults.set(unlocked, forKey: "unlockedCreatures")
        
        // Salva le date di sblocco
        let unlockDates = creatures.reduce(into: [String: Date]()) { (dict, creature) in
            if let date = creature.unlockDate {
                dict[creature.name] = date
            }
        }
        defaults.set(unlockDates, forKey: "unlockDates")
    }

    // Funzione di caricamento da UserDefaults
    func loadProgress() {
        let defaults = UserDefaults.standard
        self.totalCyclesCompleted = defaults.integer(forKey: "totalCyclesCompleted")
        let unlockedNames = defaults.array(forKey: "unlockedCreatures") as? [String] ?? []
        let unlockDates = defaults.dictionary(forKey: "unlockDates") as? [String: Date] ?? [:]
        for i in 0..<creatures.count {
            let name = creatures[i].name
            if unlockedNames.contains(name) {
                creatures[i].isUnlocked = true
                creatures[i].unlockDate = unlockDates[name]
            } else {
                creatures[i].isUnlocked = false
                creatures[i].unlockDate = nil
            }
        }
        
        if let first = creatures.first {
            if first.cycles == 0 {
                creatures[0].isUnlocked = true
            }
        }
    }

}

var sharedData = SharedData()
