//
//  SectionHeader.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/5/25.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 3.0) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Image(systemName: "chevron.right")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding([.leading, .bottom])
    }
}

#Preview {
    SectionHeader(title: "Section Title")
}
