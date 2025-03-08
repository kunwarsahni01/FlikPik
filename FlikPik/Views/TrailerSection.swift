//
//  TrailerSection.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/7/25.
//

import SwiftUI

// Section title and list of trailers
struct TrailerSection: View {
    let trailers: [MovieTrailer]?
    
    var body: some View {
        if let trailers = trailers, !trailers.isEmpty {
            VStack(alignment: .leading) {
                SectionHeader(title: "Trailers")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(trailers) { trailer in
                            TrailerThumbnail(trailer: trailer)
                        }
                    }
                    .padding(.leading)
                }
            }
            .padding(.top)
        }
    }
}

// Individual trailer thumbnail with play button
struct TrailerThumbnail: View {
    let trailer: MovieTrailer
    
    var body: some View {
        Button {
            // Use our improved deeplink method
            URLOpener.shared.openYoutube(trailer: trailer)
        } label: {
            ZStack(alignment: .center) {
                // Trailer thumbnail with full coverage
                if let thumbnailURL = trailer.thumbnailURL {
                    CachedAsyncImage(url: thumbnailURL)
//                        .resizable() // Make the image resizable
                        .scaledToFill() // Ensure it fills the entire space
                        .frame(width: 220, height: 124) // Maintain consistent size
                        .clipped() // Clip any overflow to prevent distortion
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 220, height: 124)
                        .cornerRadius(10)
                }
                
                // Play button overlay
                Circle()
                    .fill(Color.black.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                
                // Trailer title at the bottom
                VStack {
                    Spacer()
                    Text(trailer.name)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .padding(7)
                        .frame(width: 220, alignment: .leading)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                }
            }
            .frame(width: 220, height: 124)  // Fixed size for consistency
        }
    }
}

// Helper for rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Custom shape for partial corner radius
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Previews
#Preview("Trailer Thumbnail") {
    // Create a sample trailer
    let sampleTrailer = MovieTrailer(
        id: "abc123",
        name: "Official Trailer",
        key: "dQw4w9WgXcQ", // Famous Rick Astley video for testing
        site: "YouTube",
        type: "Trailer",
        thumbnailURL: MovieTrailer.youTubeThumbnail(for: "dQw4w9WgXcQ")
    )
    
    return TrailerThumbnail(trailer: sampleTrailer)
        .frame(width: 220, height: 150)
        .padding()
}

#Preview("Trailer Section") {
    // Create an array of sample trailers
    let sampleTrailers: [MovieTrailer] = [
        MovieTrailer(
            id: "1",
            name: "Official Trailer",
            key: "dQw4w9WgXcQ",
            site: "YouTube",
            type: "Trailer",
            thumbnailURL: MovieTrailer.youTubeThumbnail(for: "dQw4w9WgXcQ")
        ),
        MovieTrailer(
            id: "2",
            name: "Teaser Trailer",
            key: "K_TGMJuSynw",
            site: "YouTube",
            type: "Teaser",
            thumbnailURL: MovieTrailer.youTubeThumbnail(for: "K_TGMJuSynw")
        ),
        MovieTrailer(
            id: "3",
            name: "Final Trailer",
            key: "ICNB0VGDGVk",
            site: "YouTube",
            type: "Trailer",
            thumbnailURL: MovieTrailer.youTubeThumbnail(for: "ICNB0VGDGVk")
        )
    ]
    
    return TrailerSection(trailers: sampleTrailers)
        .padding()
}

#Preview("Empty Trailer Section") {
    TrailerSection(trailers: nil)
}
