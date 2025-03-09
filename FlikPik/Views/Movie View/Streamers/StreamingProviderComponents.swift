//
//  StreamingProviderComponents.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct StreamingProvidersList: View {
    let providers: [StreamingProvider]
    let movieTitle: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(providers) { provider in
                    StreamingProviderButton(provider: provider, movieTitle: movieTitle)
                }
            }
            .padding([.leading, .bottom])
        }
    }
}

struct StreamingProviderButton: View {
    let provider: StreamingProvider
    let movieTitle: String
    
    var body: some View {
        Button {
            URLOpener.shared.openStreamingApp(
                provider: provider,
                movieTitle: movieTitle
            )
        } label: {
            VStack {
                CachedAsyncImage(url: provider.providerLogoURL, aspectRatio: 1)
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                
                Text(provider.providerName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 80)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    // Mock provider for preview
    let mockProvider = StreamingProvider(
        id: 1,
        providerName: "Netflix",
        providerLogoURL: URL(string: "https://image.tmdb.org/t/p/w300/wwemzKWzjKYJFfCeiB57q3r4Bcm.png")!
    )
    
    return StreamingProviderButton(provider: mockProvider, movieTitle: "Test Movie")
}