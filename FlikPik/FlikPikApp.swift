//
//  FlikPikApp.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI

@main
struct FlikPikApp: App {
    @State private var tmdbController = TMDbDataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(tmdbController)
        }
    }
}
