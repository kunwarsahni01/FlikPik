//
//  URLOpener.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import Foundation
import SwiftUI

class URLOpener {
    static let shared = URLOpener()
    
    private init() {}
    
    //    func openURL(_ url: URL?) {
    //        guard let url = url else { return }
    //
    //        #if os(iOS)
    //        // For iOS, we can use the UIApplication.shared.open method
    //        if UIApplication.shared.canOpenURL(url) {
    //            UIApplication.shared.open(url)
    //        }
    //        #elseif os(macOS)
    //        // For macOS, we use NSWorkspace.shared.open
    //        NSWorkspace.shared.open(url)
    //        #endif
    //    }
    
    func openStreamingApp(provider: StreamingProvider, movieTitle: String) {
        let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = getWebURLWithSearch(provider: provider, encodedTitle: encodedTitle, title: movieTitle) {
            print(url)
            UIApplication.shared.open(url)
        } else {
            print("No link generated for \(provider.providerName)")
        }
    }

    
    private func getWebURLWithSearch(provider: StreamingProvider, encodedTitle: String, title: String) -> URL? {
        switch provider.providerName {
        case "Netflix":
            return URL(string: "https://www.netflix.com/search?q=\(encodedTitle)")
        case "Disney Plus":
            
            return URL(string: "https://www.disneyplus.com/browse/search?q=\(encodedTitle)")
        case "Amazon Video":
            return URL(string: "https://watch.amazon.com/search/?query=\(title)")
        case "Hulu":
            return URL(string: "https://www.hulu.com/search?q=\(encodedTitle)")
        case "Max":
            return URL(string: "https://www.max.com/search?q=\(encodedTitle)")
        case "Apple TV", "Apple TV+":
            return URL(string: "https://tv.apple.com/search?term=\(encodedTitle)")
        case "Peacock":
            return URL(string: "https://www.peacocktv.com/search?q=\(encodedTitle)")
        case "Paramount+":
            return URL(string: "https://www.paramountplus.com/search/?q=\(encodedTitle)")
        case "YouTube":
            return URL(string: "https://www.youtube.com/results?search_query=\(encodedTitle)")
        default:
            return nil
        }
    }
}
