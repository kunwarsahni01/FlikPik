//
//  ContentView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(TMDbDataController.self) var tmdbController
    
    var body: some View {
        MovieView(movieId: 549509)
    }
}

#Preview {
    ContentView()
        .environment(TMDbDataController())
}
