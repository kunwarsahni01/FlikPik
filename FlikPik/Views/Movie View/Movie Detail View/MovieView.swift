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
    @Environment(LineUpManager.self) var lineUpManager
    @State private var data: MovieData?
    @State var movieId: Int
    @Environment(\.dismiss) var dismiss
    var animation: Namespace.ID
    
    // For scroll control
    @State private var contentOffset: CGFloat = 0
    @State private var headerHeight: CGFloat = 600 // Approximate height of MovieHeaderView

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    // Content positioning helper
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geo.frame(in: .named("scrollView")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    VStack(spacing: 0) {
                        // Header section
                        MovieHeaderView(data: data)
                            .task {
                                fetchMovie()
                            }
                            .id("header")
                        
                        // Content sections
                        VStack(spacing: 16) {
                            CastSection(castMembers: data?.castMembers)
                            
                            TrailerSection(trailers: data?.trailers)

                            StreamingSection(providers: data?.streamingProviders, movieTitle: data?.movie.title ?? "")
                            
                            // Add some bottom padding/space
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                contentOffset = offset
                
                // When user attempts to scroll above the top edge (negative offset)
                if contentOffset > 0 {
                    // Force scroll back to the top
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scrollProxy.scrollTo("header", anchor: .top)
                    }
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
                                .foregroundColor(.white.opacity(0.5))
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white.opacity(0.5))
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
    }
    
    func fetchMovie() {
        Task {
            data = await tmdbController.getMovie(id: movieId) ?? nil
        }
    }
}
    


// Preference key to track scroll position
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    NavigationStack {
        MovieView(movieId: 549509, animation: Namespace().wrappedValue)
            .environment(TMDbDataController())
            .environment(LineUpManager())
    }
}

