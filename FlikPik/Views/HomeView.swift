//
//  HomeView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(LineUpManager.self) var lineUpManager
    @State private var showingSearchView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                SectionHeader(title: "Your LineUp")
                
                if lineUpManager.movies.isEmpty {
                    // Create a spacer to push content down from the top
                    Spacer(minLength: 150)
                    
                    HStack {
                        ContentUnavailableView {
                            Label("Your Lineup is Empty", systemImage: "film")
                                .font(.title2)
                        } description: {
                            Text("Add movies you want to watch by searching")
                                .multilineTextAlignment(.center)
                        } actions: {
                            Button {
                                showingSearchView = true
                            } label: {
                                FindMoviesButton()
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                else {
                    LineUpGridView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingSearchView = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                }
            }
        }
        .navigationDestination(isPresented: $showingSearchView) {
            SearchView()
                .navigationTitle("Search")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .navigationTitle("FlikPik")
            .environment(LineUpManager())
            .environment(TMDbDataController())
    }
}
