//
//  StreamingSection.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct StreamingSection: View {
    let providers: [StreamingProvider]?
    let movieTitle: String
    
    var body: some View {
        VStack {
            SectionHeader(title: "Streaming")
//                .padding(.leading)
            
            if let providers = providers, !providers.isEmpty {
                StreamingProvidersList(providers: providers, movieTitle: movieTitle)
            } else {
                HStack {
                    Text("Not available for streaming")
                        .foregroundColor(.secondary)
                        .italic()
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    StreamingSection(providers: nil, movieTitle: "Movie Title")
}
