//
//  ContentView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(TMDbDataController.self) var tmdbController
    @Environment(LineUpManager.self) var lineUpManager
    
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("FlikPik")
        }
    }
}

#Preview {
    ContentView()
        .environment(TMDbDataController())
        .environment(LineUpManager())
}
