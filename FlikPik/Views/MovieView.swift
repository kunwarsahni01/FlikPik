//
//  MovieView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import SwiftUI
import TMDb

struct MovieView: View {
    @Environment(TMDbDataController.self) var tmdbController
    @State private var data: MovieData?
    @State var movieId: Int
    
    var body: some View {
        ScrollView {
            MovieHeaderView(data: data)
                .task {
                    fetchMovie()
                }
            
            VStack(spacing: 16) {
                
                Spacer()
                
                CastSection(castMembers: data?.castMembers)
                
                StreamingSection(providers: data?.streamingProviders, movieTitle: data?.movie.title ?? "")

            }
        }
        .ignoresSafeArea(edges: [.top])
    }
    
    func fetchMovie() {
        Task {
            data = await tmdbController.getMovie(id: movieId) ?? nil
        }
    }
}

#Preview {
    NavigationStack {
        MovieView(movieId: 549509)
            .environment(TMDbDataController())
    }
}

#Preview {
    NavigationStack {
        MovieView(movieId: 1064213)
            .environment(TMDbDataController())
    }
}

#Preview {
    NavigationStack {
        MovieView(movieId: 974576)
            .environment(TMDbDataController())
    }
}

#Preview {
    NavigationStack {
        MovieView(movieId: 696506)
            .environment(TMDbDataController())
    }
}

