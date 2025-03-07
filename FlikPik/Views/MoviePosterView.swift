//
//  MoviePosterView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct MoviePosterView: View {
    let movie: MovieData
    // Make sure we have a consistent URL format for AsyncImage
    private var posterURL: URL? {
        if let urlString = movie.posterURL?.absoluteString,
           let url = URL(string: urlString) {
            return url
        }
        return movie.posterURL
    }
    
    var body: some View {
        VStack {
            // Add debug info
            #if DEBUG
            let _ = print("MoviePosterView - original posterURL: \(String(describing: movie.posterURL))")
            let _ = print("MoviePosterView - normalized posterURL: \(String(describing: posterURL))")
            #endif
            
            AsyncImage(url: posterURL, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .cornerRadius(8)
                        .overlay(
                            ProgressView()
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 225)
                        .cornerRadius(8)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .cornerRadius(8)
                }
            }
            .frame(height: 225)
            
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

//#Preview {
//    if let movie = MockData.sampleMovie {
//        MoviePosterView(movie: movie)
//    } else {
//        Text("No sample data")
//    }
//}

// Helper for preview
//private enum MockData {
//    static var sampleMovie: MovieData? {
//        // This is just for preview purposes
//        guard let url = URL(string: "https://example.com") else { return nil }
//        
//        let movie = Movie(
//            id: 1,
//            title: "Sample Movie Title",
//            overview: "This is a sample overview",
//            runtime: 120,
//            releaseDate: Date(),
//            posterPath: url,
//            backdropPath: url
//        )
//        
//        return MovieData(
//            movie: movie,
//            backdropURL: url,
//            posterURL: url,
//            logoURL: url
//        )
//    }
//}
