////
////  InlineOverviewView.swift
////  FlikPik
////
////  Created by Kunwar Sahni on 3/9/25.
////
//
//import SwiftUI
//
//struct InlineOverviewView: View {
//    let overview: String
//    @State private var showFullOverview = false
//    @State private var needsTruncation = false
//    
//    var body: some View {
//        Group {
//            if needsTruncation {
//                // For long texts: truncated text with an inline "more" button
//                ZStack(alignment: .topLeading) {
//                    // Placeholder text with 3 line limit (for proper layout)
//                    Text(overview)
//                        .lineLimit(3)
//                        .opacity(0)
//                        .layoutPriority(1)
//                    
//                    // Custom text with inline "more" button
//                    VStack(alignment: .leading, spacing: 0) {
//                        if overview.count > 130 {
//                            Text(getTruncatedText().dropLast() + " ") +
//                            Text("MORE")
//                                .foregroundColor(.white)
//                                .fontWeight(.medium)
//                        } else {
//                            Text(overview)
//                        }
//                    }
//                    .onTapGesture {
//                        showFullOverview = true
//                    }
//                }
//            } else {
//                // For short texts: just show the text normally
//                Text(overview)
//                    .lineLimit(3)
//                    .task {
//                        print("the overview is coming in short?")
//                    }
//            }
//        }
//        .foregroundColor(.white)
//        .padding(.horizontal, 21.0)
//        .task {
//            // Simple estimate if truncation likely needed
//            // This can be adjusted based on typical font/screen size
//            needsTruncation = overview.count > 130
//        }
//        .sheet(isPresented: $showFullOverview) {
//            FullOverviewSheet(overview: overview)
//        }
//    }
//    
//    // Returns a truncated version of the text for displaying with "more" button
//    private func getTruncatedText() -> String {
//        // Simple truncation (around 90% of what would fit in 2.5 lines)
//        // This ensures room for the "... more" text
//        let approximateCharLimit = 120
//        
//        if overview.count <= approximateCharLimit {
//            return overview
//        }
//        
//        // Find a good breaking point (period, comma, space, etc.)
//        let truncatedIndex = overview.index(overview.startIndex, offsetBy: min(approximateCharLimit, overview.count))
//        
//        // Look backwards from the target position to find a good breaking point
//        let goodBreakingPoints: [Character] = [".", ",", " ", "?", "!", ";", ":"]
//        let punctuationMarks: [Character] = [".", ",", "?", "!", ";", ":"]
//        
//        // Search backward for a good breaking point
//        var searchIndex = truncatedIndex
//        while searchIndex > overview.startIndex {
//            searchIndex = overview.index(before: searchIndex)
//            if goodBreakingPoints.contains(overview[searchIndex]) {
//                // For a space or punctuation, don't include them to avoid clashing with ellipsis
//                if punctuationMarks.contains(overview[searchIndex]) || overview[searchIndex] == " " {
//                    return String(overview[..<searchIndex])
//                } else {
//                    // For other breaking characters, include them
//                    return String(overview[...searchIndex])
//                }
//            }
//        }
//        
//        // If no good breaking point found, just truncate at the approximate limit
//        return String(overview[..<truncatedIndex])
//    }
//}
//
//// Sheet to display the full overview
//struct FullOverviewSheet: View {
//    let overview: String
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                Text(overview)
//                    .foregroundColor(.white)
//                    .padding()
//            }
//            .background(Color.black)
//            .navigationTitle("Overview")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//        .presentationDetents([.medium, .large])
//        .preferredColorScheme(.dark)
//    }
//}
//
//#Preview("Long Overview") {
//    InlineOverviewView(overview: "This is a long movie overview that will definitely get truncated because it contains a lot of text. It discusses the plot, the characters, and various other aspects of the movie that would be interesting to know. The text is intentionally verbose to ensure truncation occurs and the More button appears.")
//}
//
//#Preview("Short Overview") {
//    InlineOverviewView(overview: "A short overview that fits within the line limit.")
//}
