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
    @Environment(\.dismiss) var dismiss
    var animation: Namespace.ID

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
        .navigationTransition(.zoom(sourceID: movieId, in: animation))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "chevron.backward")
                            .fontWeight(.bold)
                            .foregroundStyle(.regularMaterial)
                    }
                }
            }
        }
        .navigationTitle("")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchMovie() {
        Task {
            data = await tmdbController.getMovie(id: movieId) ?? nil
        }
    }
}
//
//#Preview {
//    NavigationStack {
//        MovieView(movieId: 549509, animation: Namespace.ID())
//            .environment(TMDbDataController())
//    }
//}
//
//#Preview {
//    NavigationStack {
//        MovieView(movieId: 1064213, animation: Namespace.ID())
//            .environment(TMDbDataController())
//    }
//}
//
//#Preview {
//    NavigationStack {
//        MovieView(movieId: 974576, animation: Namespace.ID())
//            .environment(TMDbDataController())
//    }
//}
//
//#Preview {
//    NavigationStack {
//        MovieView(movieId: 696506, , animation: 1)
//            .environment(TMDbDataController())
//    }
//}

