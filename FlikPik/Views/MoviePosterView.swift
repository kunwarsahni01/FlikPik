//
//  MoviePosterView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI
import TMDb

struct MoviePosterView: View {
    let movie: MovieData
    
    var body: some View {
        VStack {
            if let posterURL = movie.posterURL {
                CachedAsyncImage(url: posterURL, aspectRatio: 2/3)
                    .frame(height: 225)
                    .cornerRadius(8)
            } else {
                ImageLoadFailure(aspectRatio: 2/3)
                    .frame(height: 225)
            }
            
            Text(movie.movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 40)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    if let movie = MockData.sampleMovie {
        MoviePosterView(movie: movie)
    } else {
        Text("No sample data")
    }
}

// Helper for preview
private enum MockData {
    static var sampleMovie: MovieData? {
        // This is just for preview purposes
        guard let url = URL(string: "https://example.com") else { return nil }
        
        let movie = Movie(
            id: 1,
            title: "Sample Movie Title",
            overview: "This is a sample overview",
            runtime: 120,
            releaseDate: Date(),
            posterPath: url,
            backdropPath: url
        )
        
        return MovieData(
            movie: movie,
            backdropURL: url,
            posterURL: url,
            logoURL: url
        )
    }
}
