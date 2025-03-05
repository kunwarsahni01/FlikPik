//
//  ActorDetailView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI
import Glur

struct ActorDetailView: View {
    @Environment(TMDbDataController.self) var tmdbController
    let actorId: Int
    let actorName: String
    let profileURL: URL?
    
    @State private var movies: [TMDbDataController.ActorMovie]?
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Actor Header
                HStack(spacing: 16) {
                    AsyncImage(url: profileURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 120)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(actorName)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding()
                
                // Filmography Section
                Text("Filmography")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if let actorMovies = movies, !actorMovies.isEmpty {
                    // Movies List
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(actorMovies, id: \.id) { movie in
                            NavigationLink(destination: MovieView(movieId: movie.id)) {
                                HStack(spacing: 16) {
                                    // Movie Poster
                                    AsyncImage(url: movie.posterURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 80, height: 120)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 120)
                                            .cornerRadius(8)
                                    }
                                    
                                    // Movie Details
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(movie.title)
                                            .font(.headline)
                                            .lineLimit(2)
                                            .foregroundColor(.primary)
                                        
                                        if let date = movie.releaseDate {
                                            Text(formatDate(date))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Text(movie.character)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                } else {
                    Text("No movies found for this actor")
                        .foregroundColor(.secondary)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
        }
        .navigationTitle(actorName)
        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(.blue)
//        .toolbarColorScheme(.dark)
//        .toolbar(.hidden, for: .navigationBar)

        .task {
            await loadActorMovies()
        }
    }
    
    private func loadActorMovies() async {
        isLoading = true
        movies = await tmdbController.fetchActorFilmography(actorId: actorId)
        isLoading = false
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        ActorDetailView(actorId: 1245, actorName: "Scarlett Johansson", profileURL: nil)
            .environment(TMDbDataController())
    }
}
