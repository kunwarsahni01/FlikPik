//
//  MovieHeaderView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI
import Glur

struct MovieHeaderView: View {
    let data: MovieData?
    
    var body: some View {
        ZStack {
            Color.black
                .frame(width: 420, height: 605.9999999999999)
            
            // Backdrop image with blur effect
            VStack {
                AsyncImage(url: data?.backdropURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .scaledToFill()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .scaledToFill()
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            )
                    }
                }
                .frame(width: 420, height: 615)
                .glur(radius: 15.0,
                      offset: 0.5, 
                      interpolation: 0.5, 
                      direction: .down
                )
                
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


#Preview {
    MovieHeaderView(data: nil)
        .environment(LineUpManager())
}
