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
            // Debug: Print what we're adding
            print("Adding movie to lineup: ID=\(movie.id), posterURL=\(String(describing: movie.posterURL))")
            
            // Add new movie to the beginning of the array
            movies.insert(movie, at: 0)
            saveLineUp()
        } else {
            // Movie exists, update it (might fix URL issues)
            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                print("Updating existing movie in lineup: ID=\(movie.id)")
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
        }
    }
    
    @MainActor
    private func loadLineUp() {
        if let savedLineUp = UserDefaults.standard.data(forKey: lineUpKey) {
            do {
                let decodedLineUp = try JSONDecoder().decode([MovieData].self, from: savedLineUp)
                movies = decodedLineUp
                print("Successfully loaded \(movies.count) movies from lineup")
                
                // Debug: Print the first movie's poster URL if available
                if let firstMovie = movies.first {
                    print("First movie poster URL: \(String(describing: firstMovie.posterURL))")
                }
            } catch {
                print("Error decoding lineup: \(error)")
                // If there's an error, clear the corrupted data
                UserDefaults.standard.removeObject(forKey: lineUpKey)
            }
        }
    }
    
    // Method to clear lineup for debugging
    @MainActor
    func clearLineUp() {
        movies = []
        UserDefaults.standard.removeObject(forKey: lineUpKey)
    }
}
