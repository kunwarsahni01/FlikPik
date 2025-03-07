//
//  LineUpComponents.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

// Button for finding movies in empty state
struct FindMoviesButton: View {
    var body: some View {
        Text("Find Movies")
            .fontWeight(.medium)
            .frame(width: 200, height: 45)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(12)
    }
}

// Reusable button for LineUp actions (add/remove)
struct LineUpActionButton: View {
    let movie: MovieData
    @Environment(LineUpManager.self) var lineUpManager
    @State private var inLineUp: Bool = false
    @State private var showingAlert = false
    let onAdd: (() -> Void)?
    let onRemove: (() -> Void)?
    
    init(movie: MovieData, onAdd: (() -> Void)? = nil, onRemove: (() -> Void)? = nil) {
        self.movie = movie
        self.onAdd = onAdd
        self.onRemove = onRemove
    }
    
    var body: some View {
        Button(action: {
            if inLineUp {
                lineUpManager.removeFromLineUp(movie)
                onRemove?()
            } else {
                lineUpManager.addToLineUp(movie)
                showingAlert = true
                onAdd?()
            }
            inLineUp.toggle()
        }) {
            HStack {
                Image(systemName: inLineUp ? "checkmark" : "plus")
                    .font(.system(size: 16))
                Text(inLineUp ? "In Lineup" : "Add to Lineup")
            }
            .fontWeight(.medium)
            .frame(width: 250, height: 45)
            .foregroundColor(inLineUp ? .white : .black)
            .background(inLineUp ? Color.gray : Color.white)
            .cornerRadius(12)
        }
//        .alert("Added to Lineup", isPresented: $showingAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text("This movie has been added to your lineup.")
//        }
        .onAppear {
            inLineUp = lineUpManager.isInLineUp(movie)
        }
    }
}

// Standard context menu for removing movies from lineup
struct LineUpContextMenu: ViewModifier {
    let movie: MovieData
    @Environment(LineUpManager.self) var lineUpManager
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(role: .destructive, action: {
                    lineUpManager.removeFromLineUp(movie)
                }) {
                    Label("Remove from Lineup", systemImage: "trash")
                }
            }
    }
}

extension View {
    func lineUpContextMenu(for movie: MovieData) -> some View {
        modifier(LineUpContextMenu(movie: movie))
    }
}

#Preview {
    VStack {
        FindMoviesButton()
    }
}
