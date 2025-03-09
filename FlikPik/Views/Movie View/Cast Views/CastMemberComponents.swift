//
//  CastMemberComponents.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct CastMembersList: View {
    let castMembers: [CastMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(castMembers, id: \.id) { castMember in
                    CastMemberCard(castMember: castMember)
                }
            }
            .padding(.leading)
        }
    }
}

struct CastMemberCard: View {
    let castMember: CastMember
    
    var body: some View {
        NavigationLink(destination: ActorDetailView(actorId: castMember.id, actorName: castMember.name, profileURL: castMember.profileURL)) {
            VStack {
                Group {
                    if let profileURL = castMember.profileURL {
                        CachedAsyncImage(url: profileURL, aspectRatio: 1)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 80)
                    }
                }
                
                Text(castMember.name)
                    .font(.caption)
                    .bold()
                    .frame(width: 100)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(castMember.character)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 100)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    // Create a mock cast member for preview
    let castMember = CastMember(
        id: 1,
        name: "Actor Name",
        character: "Character Name",
        profileURL: URL(string: "https://example.com/image.jpg")
    )
    
    return CastMemberCard(castMember: castMember)
}
