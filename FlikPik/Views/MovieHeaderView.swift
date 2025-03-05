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
                AsyncImage(url: data?.backdropURL){ result in
                    result.image?
                        .resizable()
                        .scaledToFill()
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
                AsyncImage(url: data?.logoURL){ result in
                    result.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 80)
                }
                .padding()
                
                MovieMetadataView(releaseDate: data?.movie.releaseDate, runtime: data?.movie.runtime)
                
                AddToLineupButton()
                
                Text(data?.movie.overview ?? "")
                    .foregroundColor(Color.white)
                    .lineLimit(3)
                    .padding(.horizontal, 21.0)
            }
            .padding(.top, 300)
        }
    }
}

struct AddToLineupButton: View {
    var body: some View {
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
    }
}

#Preview {
    MovieHeaderView(data: nil)
}