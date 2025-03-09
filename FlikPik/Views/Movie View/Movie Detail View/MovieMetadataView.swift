//
//  MovieMetadataView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct MovieMetadataView: View {
    let releaseDate: Date?
    let runtime: Int?
    
    var body: some View {
        HStack {
            Text(formatDate(releaseDate))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.5))
                .foregroundStyle(.thinMaterial)
            
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 3, height: 3)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.5))
            
            Text(formatRuntime(runtime))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.5))
                .foregroundStyle(.thinMaterial)
        }
        .padding(.horizontal)
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
    MovieMetadataView(releaseDate: Date(), runtime: 120)
        .background(Color.black)
}
