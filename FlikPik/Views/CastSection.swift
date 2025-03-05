//
//  CastSection.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct CastSection: View {
    let castMembers: [CastMember]?
    
    var body: some View {
        VStack {
            SectionHeader(title: "Cast")
//                .padding(.leading)
            
            if let castMembers = castMembers, !castMembers.isEmpty {
                CastMembersList(castMembers: castMembers)
            } else {
                HStack {
                    Text("Cast information unavailable")
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
    CastSection(castMembers: nil)
}
