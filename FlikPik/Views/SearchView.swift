//
//  SearchView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


struct SearchView: View {
    @Environment(TMDbDataController.self) var tmdbController
    @State private var searchText = ""
    @State private var searchResults: [TMDbDataController.MovieSearchResult]?
    @State private var isSearching = false
    @State private var debouncedText = ""
    @State private var hasSearchedOnce = false
    @Namespace var animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Empty state (initial or cleared search)
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Search Movies",
                        systemImage: "film.stack",
                        description: Text("Search for any movie to get started")
                    )
                    .symbolVariant(.fill)
                    .transition(.opacity)
                }
                
                // Results list
                else if let results = searchResults, !(isSearching && !hasSearchedOnce) {
                    if results.isEmpty {
                        ContentUnavailableView(
                            "No Results Found",
                            systemImage: "film",
                            description: Text("Try a different search term")
                        )
                        .transition(.opacity)
                    } else {
                        VStack {
                            // Show count of results
                            Text("\(results.count) results found")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 8)
                            
                            List {
                                ForEach(results) { movie in
                                    NavigationLink {
                                        MovieView(movieId: movie.id, animation: animation)
                                    } label: {
                                        SearchResultRow(movie: movie)
                                            .matchedTransitionSource(id: movie.id, in: animation)
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                        .transition(.opacity)
                    }
                }
                
                // Loading indicator (only for first search)
                if isSearching && !hasSearchedOnce {
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                                .background(Color(.systemBackground).opacity(0.8))
                                .cornerRadius(10)
                        )
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: searchText.isEmpty)
            .animation(.easeInOut(duration: 0.3), value: isSearching)
            .animation(.easeInOut(duration: 0.3), value: searchResults?.count)
            
            .navigationTitle("Search")
            .searchable(
                text: $searchText,
                prompt: "Search for movies..."
            )
            .autocorrectionDisabled()
            .onSubmit(of: .search) {
                debouncedSearch()
            }
            .onChange(of: searchText) { _, newValue in
                if newValue.isEmpty {
                    withAnimation {
                        searchResults = nil
                        debouncedText = ""
                    }
                } else {
                    // Use debouncing to avoid frequent API calls
                    debounce(newValue: newValue)
                }
            }
        }
    }
    
    // Debounce mechanism to avoid rapid API calls
    func debounce(newValue: String) {
        // Cancel existing search if user is still typing
        debouncedText = newValue
        
        // Minimum text length for search
        guard newValue.count >= 2 else { return }
        
        // Debounce for 400ms
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Only search if the text hasn't changed in the delay period
            if debouncedText == newValue {
                debouncedSearch()
            }
        }
    }
    
    private func debouncedSearch() {
        // Avoid searching the same term twice
        guard !debouncedText.isEmpty, debouncedText == searchText else { return }
        
        performSearch()
    }
    
    private func performSearch() {
        Task {
            withAnimation {
                isSearching = true
            }
            
            let results = await tmdbController.searchMovies(query: searchText)
            
            // Small delay to ensure UI smoothness
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            
            withAnimation {
                // If nil results were returned (which shouldn't happen now with our changes),
                // convert to empty array for consistent handling
                searchResults = results ?? []
                isSearching = false
                hasSearchedOnce = true
            }
        }
    }
}

struct SearchResultRow: View {
    let movie: TMDbDataController.MovieSearchResult
    
    var body: some View {
        HStack(spacing: 16) {
            // Movie poster
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                }
            }
            
            // Movie details
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let releaseDate = movie.releaseDate {
                    Text(formatDate(releaseDate))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    SearchView()
        .environment(TMDbDataController())
}
