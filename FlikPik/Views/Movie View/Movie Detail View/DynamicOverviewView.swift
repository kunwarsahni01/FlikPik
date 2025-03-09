//
//  DynamicOverviewView.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/9/25.
//

import SwiftUI

struct DynamicOverviewView: View {
    let overview: String?
    @State private var showFullOverview = false
    @State private var needsTruncation = false
    
    var body: some View {
        Group {
            if let text = overview, !text.isEmpty {
                if needsTruncation {
                    // For long texts: truncated text with an inline "more" button
                    ZStack(alignment: .topLeading) {
                        // Placeholder text with 3 line limit (for proper layout)
                        Text(text)
                            .lineLimit(3)
                            .opacity(0)
                            .layoutPriority(1)
                        
                        // Custom text with inline "more" button
                        VStack(alignment: .leading, spacing: 0) {
                            if text.count > 130 {
                                Text(getTruncatedText(from: text) + " ") +
                                Text("MORE")
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                            } else {
                                Text(text)
                            }
                        }
                        .onTapGesture {
                            showFullOverview = true
                        }
                    }
                } else {
                    // For short texts: just show the text normally
                    Text(text)
                        .lineLimit(3)
                }
            } else {
                // Placeholder when overview isn't available yet
                Text("Loading overview...")
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .opacity(0.7)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 21.0)
        .onChange(of: overview) { _, _ in
            updateTruncationState()
        }
        .onAppear {
            updateTruncationState()
        }
        .sheet(isPresented: $showFullOverview) {
            if let text = overview, !text.isEmpty {
                FullOverviewSheet(overview: text)
            }
        }
    }
    
    private func updateTruncationState() {
        // Only enable truncation when we have actual content to display
        if let text = overview, !text.isEmpty {
            // Simple estimate if truncation likely needed
            // This can be adjusted based on typical font/screen size
            needsTruncation = text.count > 130
        } else {
            needsTruncation = false
        }
    }
    
    // Returns a truncated version of the text for displaying with "more" button
    private func getTruncatedText(from text: String) -> String {
        // Simple truncation (around 90% of what would fit in 2.5 lines)
        // This ensures room for the "... more" text
        let approximateCharLimit = 120
        
        if text.count <= approximateCharLimit {
            return text
        }
        
        // Find a good breaking point (period, comma, space, etc.)
        let truncatedIndex = text.index(text.startIndex, offsetBy: min(approximateCharLimit, text.count))
        
        // Look backwards from the target position to find a good breaking point
        let goodBreakingPoints: [Character] = [".", ",", " ", "?", "!", ";", ":"]
        let punctuationMarks: [Character] = [".", ",", "?", "!", ";", ":"]
        
        // Search backward for a good breaking point
        var searchIndex = truncatedIndex
        while searchIndex > text.startIndex {
            searchIndex = text.index(before: searchIndex)
            if goodBreakingPoints.contains(text[searchIndex]) {
                // For a space or punctuation, don't include them to avoid clashing with ellipsis
                if punctuationMarks.contains(text[searchIndex]) || text[searchIndex] == " " {
                    return String(text[..<searchIndex])
                } else {
                    // For other breaking characters, include them
                    return String(text[...searchIndex])
                }
            }
        }
        
        // If no good breaking point found, just truncate at the approximate limit
        return String(text[..<truncatedIndex])
    }
}

// Sheet to display the full overview
struct FullOverviewSheet: View {
    let overview: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(overview)
                    .foregroundColor(.white)
                    .padding()
            }
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview("Long Overview") {
    DynamicOverviewView(overview: "This is a long movie overview that will definitely get truncated because it contains a lot of text. It discusses the plot, the characters, and various other aspects of the movie that would be interesting to know. The text is intentionally verbose to ensure truncation occurs and the More button appears.")
       
}

#Preview("Short Overview") {
    DynamicOverviewView(overview: "A short overview that fits within the line limit.")
}

#Preview("Loading State") {
    DynamicOverviewView(overview: nil)

}
