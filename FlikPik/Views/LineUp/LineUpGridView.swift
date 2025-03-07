//
//  LineUpGridView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

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
    LineUpGridView()
        .environment(LineUpManager())
}
