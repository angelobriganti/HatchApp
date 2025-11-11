//
//  ContentView.swift
//  AppTimer
//
//  Created by AFP Student 56 on 03/11/25.
//

import SwiftUI

struct ContentView: View {
    
    // Questo init() serve per la transizione "fade"
    // e rimuove lo sfondo bianco della TabBar
    init() {
        // Rende lo sfondo della barra della TabView trasparente
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Applica questa trasparenza
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Collection", systemImage: "tray.2") {
                CollectionView()
            }
        }
    }
}

#Preview {
    ContentView()
}
