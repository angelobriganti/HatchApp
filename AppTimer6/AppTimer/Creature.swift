//
//  Creature.swift
//  AppTimer
//
//  Created by AFP Student 56 on 04/11/25.
//

import SwiftUI

struct Creature: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var image: String
    var eggImage: String
    var cycles: Int
    var isUnlocked: Bool = false
    var unlockDate: Date? = nil // Memorizza la data di sblocco
}
