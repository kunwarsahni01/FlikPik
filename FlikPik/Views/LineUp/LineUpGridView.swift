//
//  LineUpGridView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI
import TMDb

struct LineUpGridView: View {
    @Environment(LineUpManager.self) var lineUpManager
    @Namespace var animation

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
            ForEach(lineUpManager.movies) { movie in
                NavigationLink {
                    MovieView(movieId: movie.id, animation: animation)
                } label: {
                    MoviePosterView(movie: movie)
                        .matchedTransitionSource(id: movie.id, in: animation)
                }
                .lineUpContextMenu(for: movie)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    // Create a sample LineUpManager with mock data
    let lineUpManager = LineUpManager()
    
    // Add sample movies to the lineup
    Task { @MainActor in
        // Movie 1
        let movie1 = Movie(
            id: 1,
            title: "The Dark Knight",
            overview: "When the menace known as the Joker wreaks havoc on Gotham City, Batman must accept one of the greatest tests of his ability to fight injustice.",
            runtime: 152,
            releaseDate: Date(),
            posterPath: URL(string: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "https://image.tmdb.org/t/p/original/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg")
        )
        
        let movieData1 = MovieData(
            movie: movie1,
            backdropURL: URL(string: "https://image.tmdb.org/t/p/original/hkBaDkMWbLaf8B1lsWsKX7Ew3Xq.jpg"),
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            logoURL: nil
        )
        
        // Movie 2
        let movie2 = Movie(
            id: 2,
            title: "Interstellar",
            overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
            runtime: 169,
            releaseDate: Date(),
            posterPath: URL(string: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"),
            backdropPath: URL(string: "https://image.tmdb.org/t/p/original/xJHokMbljvjADYdit5fK5VQsXEG.jpg")
        )
        
        let movieData2 = MovieData(
            movie: movie2,
            backdropURL: URL(string: "https://image.tmdb.org/t/p/original/xJHokMbljvjADYdit5fK5VQsXEG.jpg"),
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"),
            logoURL: nil
        )
        
        // Movie 3
        let movie3 = Movie(
            id: 3,
            title: "Inception",
            overview: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
            runtime: 148,
            releaseDate: Date(),
            posterPath: URL(string: "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg"),
            backdropPath: URL(string: "https://image.tmdb.org/t/p/original/s3TBrRGB1iav7gFOCNx3H31MoES.jpg")
        )
        
        let movieData3 = MovieData(
            movie: movie3,
            backdropURL: URL(string: "https://image.tmdb.org/t/p/original/s3TBrRGB1iav7gFOCNx3H31MoES.jpg"),
            posterURL: URL(string: "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg"),
            logoURL: nil
        )
        
        // Add movies to lineup
        lineUpManager.addToLineUp(movieData1)
        lineUpManager.addToLineUp(movieData2)
        lineUpManager.addToLineUp(movieData3)
    }
    
    return NavigationStack {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("My Lineup")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                LineUpGridView()
            }
        }
        .background(Color.black)
        .environment(lineUpManager)
    }
    .preferredColorScheme(.dark)
}
