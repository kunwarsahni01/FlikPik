//
//  LineUpManager.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import Foundation
import SwiftUI

@Observable
class LineUpManager {
    private let lineUpKey = "UserLineUp"
    
    @MainActor
    var movies: [MovieData] = []
    
    @MainActor
    init() {
        loadLineUp()
    }
    
    @MainActor
    func addToLineUp(_ movie: MovieData) {
        // Check if movie already exists in lineup
        if !movies.contains(where: { $0.id == movie.id }) {
            // Add new movie to the beginning of the array
            movies.insert(movie, at: 0)
            saveLineUp()
        } else {
            // Movie exists, update it (might fix URL issues)
            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                movies[index] = movie
                saveLineUp()
            }
        }
    }
    
    @MainActor
    func removeFromLineUp(_ movie: MovieData) {
        movies.removeAll { $0.id == movie.id }
        saveLineUp()
    }
    
    @MainActor
    func isInLineUp(_ movie: MovieData) -> Bool {
        return movies.contains { $0.id == movie.id }
    }
    
    @MainActor
    private func saveLineUp() {
        // Save only essential movie data to reduce storage size
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: lineUpKey)
            print("Successfully saved lineup to UserDefaults")
        } else {
            print("⚠️ ERROR: Failed to encode lineup for saving")
        }
    }
    
    @MainActor
    private func loadLineUp() {
        if let savedLineUp = UserDefaults.standard.data(forKey: lineUpKey) {
            do {
                print("Found saved lineup data, attempting to decode...")
                let decodedLineUp = try JSONDecoder().decode([MovieData].self, from: savedLineUp)
                movies = decodedLineUp
                print("Successfully loaded \(movies.count) movies from lineup")
                
            } catch {
                print("⚠️ ERROR: Failed decoding lineup: \(error)")
                print("Error description: \(error.localizedDescription)")
                // If there's an error, clear the corrupted data
                UserDefaults.standard.removeObject(forKey: lineUpKey)
            }
        } else {
            print("No saved lineup found in UserDefaults")
        }
    }
    
    // Method to clear lineup for debugging
    @MainActor
    func clearLineUp() {
        movies = []
        UserDefaults.standard.removeObject(forKey: lineUpKey)
    }
}
