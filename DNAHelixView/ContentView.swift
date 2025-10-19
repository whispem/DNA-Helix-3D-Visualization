//
//  ContentView.swift
//  DNAHelixView
//
//  Created by Emilie on 19/10/2025.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        DNAHelixView()
            .edgesIgnoringSafeArea(.all) // Assure que la scène 3D occupe tout l'écran
    }
}

#Preview {
    ContentView()
}
