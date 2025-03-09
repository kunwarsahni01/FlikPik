//
//  MovieHeaderView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI
import TMDb
import Glur

struct MovieHeaderView: View {
    let data: MovieData?
    
    var body: some View {
        ZStack {
            Color.black
                .frame(width: 420, height: 605.9999999999999)
            
            // Backdrop image with blur effect
            VStack {
//                AsyncImage(url: data?.backdropURL) { phase in
//                    switch phase {
//                    case .empty:
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.3))
//                            .scaledToFill()
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                    case .failure:
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.3))
//                            .scaledToFill()
//                            .overlay(
//                                Image(systemName: "photo")
//                                    .foregroundColor(.white)
//                                    .font(.largeTitle)
//                            )
//                    }
//                }
                if let backdropURL = data?.backdropURL {
                    CachedAsyncImage(url: backdropURL)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 420, height: 615)
                        .glur(radius: 15.0,
                              offset: 0.5,
                              interpolation: 0.5,
                              direction: .down
                        )
                }
                
                Spacer()
            }
            
            // Movie info overlay
            VStack {
                Group {
                    if let logoURL = data?.logoURL {
                        CachedAsyncImage(url: logoURL)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 80)
                    } else {
                        // Show title as text if no logo is available
                        if let title = data?.movie.title {
                            Text(title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 300, height: 80)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 300, height: 80)
                        }
                    }
                }
                .padding()
                
                MovieMetadataView(releaseDate: data?.movie.releaseDate, runtime: data?.movie.runtime)
                
                if let movieData = data {
                    LineUpActionButton(movie: movieData)
                        .padding(.top, 5.0)
                        .padding(.bottom, 7.0)
                } else {
                    // Placeholder button for when no movie data is available
                    Button(action: {}) {
                        Text("Add to Lineup")
                            .fontWeight(.medium)
                            .frame(width: 250, height: 45)
                            .foregroundColor(.black)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(12)
                    }
                    .disabled(true)
                    .padding(.top, 5.0)
                    .padding(.bottom, 7.0)
                }
                
                Text(data?.movie.overview ?? "")
                    .foregroundColor(Color.white)
                    .lineLimit(3)
                    .padding(.horizontal, 21.0)
            }
            .padding(.top, 300)
        }
    }
}


#Preview("With Logo") {
    // Create sample movie data with a logo
    let movie = Movie(
        id: 299536,
        title: "Avengers: Infinity War",
        overview: "As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable power, and use them to inflict his twisted will on all of reality. Everything the Avengers have fought for has led up to this moment - the fate of Earth and existence itself has never been more uncertain.",
        runtime: 149,
        releaseDate: ISO8601DateFormatter().date(from: "2018-04-25T00:00:00Z"),
        posterPath: URL(string: "https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg"),
        backdropPath: URL(string: "https://image.tmdb.org/t/p/original/mDfJG3LC3Dqb67AZ52x3Z0jU0uB.jpg")
    )
    
    let movieData = MovieData(
        movie: movie,
        backdropURL: URL(string: "https://image.tmdb.org/t/p/original/mDfJG3LC3Dqb67AZ52x3Z0jU0uB.jpg"),
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg"),
        logoURL: URL(string: "https://image.tmdb.org/t/p/original/x1DjYUu8Q4ueCRSaimBl9h4RV7G.png"),
        streamingProviders: [
            StreamingProvider(
                id: 337, 
                providerName: "Disney Plus", 
                providerLogoURL: URL(string: "https://image.tmdb.org/t/p/original/7rwgEs15tFwyR9NPQ5vpzxTj19Q.jpg")!
            )
        ]
    )
    
    return MovieHeaderView(data: movieData)
        .environment(LineUpManager())
        .ignoresSafeArea(edges: [.top])
}

#Preview("Without Logo") {
    // Create sample movie data without a logo
    let movie = Movie(
        id: 550,
        title: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
        runtime: 139,
        releaseDate: ISO8601DateFormatter().date(from: "1999-10-15T00:00:00Z"),
        posterPath: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
        backdropPath: URL(string: "https://image.tmdb.org/t/p/original/rr7E0NoGKxvbkb89eR1GwfoYjpA.jpg")
    )
    
    let movieData = MovieData(
        movie: movie,
        backdropURL: URL(string: "https://image.tmdb.org/t/p/original/rr7E0NoGKxvbkb89eR1GwfoYjpA.jpg"),
        posterURL: URL(string: "https://image.tmdb.org/t/p/w500/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"),
        logoURL: nil
    )
    
    return MovieHeaderView(data: movieData)
        .environment(LineUpManager())
        .ignoresSafeArea(edges: [.top])
}

#Preview("Loading State") {
    MovieHeaderView(data: nil)
        .environment(LineUpManager())
        .ignoresSafeArea(edges: [.top])
}
