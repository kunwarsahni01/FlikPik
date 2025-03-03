//
//  MovieView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI
import TMDb
import Glur

struct MovieView: View {
    @Environment(TMDbDataController.self) var tmdbController
    @State private var data: MovieData?
    @State private var urlImage: URL?
    @State var movieId: Int
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.black
                    .frame(width: 420, height: 605.9999999999999)
                
                VStack {
                    AsyncImage(url: data?.backdropURL){ result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 420, height: 615)
                    .glur(radius: 15.0, // The total radius of the blur effect when fully applied.
                          offset: 0.5, // The distance from the view's edge to where the effect begins, relative to the view's size.
                          interpolation: 0.5, // The distance from the offset to where the effect is fully applied, relative to the view's size.
                          direction: .down // The direction in which the effect is applied.
                    )
                    
                    Spacer()
                }
                
                VStack {
                    AsyncImage(url: data?.logoURL){ result in
                        result.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 80)
                    }
                    .padding()
                    
                    HStack {
                        Text(formatDate(data?.movie.releaseDate))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.thinMaterial)
                        
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 3, height: 3)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(formatRuntime(data?.movie.runtime))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.thinMaterial)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {print("Added to Lineup")}) {
                        Text("Add to Lineup")
                            .fontWeight(.medium)
                            .frame(width: 250, height: 45)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 5.0)
                    .padding(.bottom, 7.0)
                    
                    Text(data?.movie.overview ?? "")
                        .foregroundColor(Color.white)
                        .lineLimit(3)
                        .padding(.horizontal, 21.0)
                }
                .padding(.top, 300)
                
            }
            .task {
                fetchMovie()
            }
            
            VStack {
                HStack(spacing: 3.0) {
                    Text("Streaming")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.right")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding([.leading, .bottom])
                
                if let providers = data?.streamingProviders, !providers.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(providers, id: \.providerName) { provider in
                                VStack {
                                    AsyncImage(url: provider.providerLogoURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                    }
                                    
                                    Text(provider.providerName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(width: 80)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.leading)
                    }
                } else {
                    HStack {
                        Text("Not available for streaming")
                            .foregroundColor(.secondary)
                            .italic()
                            .padding(.leading)
                        Spacer()
                    }
//                    .padding()
                }
            }

        }
        .ignoresSafeArea(edges: [.top])
        
    }
    
    func fetchMovie() {
        Task {
            data = await tmdbController.getMovie(id: movieId) ?? nil
        }
    }
    
    func formatRuntime(_ runtime: Int?) -> String {
        guard let runtime = runtime else { return "Unknown runtime" }
        
        let hours = runtime / 60
        let minutes = runtime % 60
        
        if hours > 0 {
            return minutes > 0 ? "\(hours) hr \(minutes) min" : "\(hours) hr"
        } else {
            return "\(minutes) min"
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Format for "Month Year"
        
        return formatter.string(from: date)
    }
}

#Preview {
    MovieView(movieId: 549509)
        .environment(TMDbDataController())
}

#Preview {
    MovieView(movieId: 1064213)
        .environment(TMDbDataController())
}

#Preview {
    MovieView(movieId: 974576)
        .environment(TMDbDataController())
}

#Preview {
    MovieView(movieId: 696506)
        .environment(TMDbDataController())
}

