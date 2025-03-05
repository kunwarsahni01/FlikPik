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
    
    func openURL(_ url: URL?) {
        guard let url = url else { return }
        
        #if os(iOS)
        // For iOS, we can use the UIApplication.shared.open method
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        #elseif os(macOS)
        // For macOS, we use NSWorkspace.shared.open
        NSWorkspace.shared.open(url)
        #endif
    }
    
    func openStreamingApp(provider: StreamingProvider, movieTitle: String) {
        // Get an encoded version of the movie title for query parameters
        let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Try to open with a deep link that includes a search for the movie
        if let deepLinkWithSearch = getDeepLinkWithSearch(provider: provider, encodedTitle: encodedTitle) {
            #if os(iOS)
            if UIApplication.shared.canOpenURL(deepLinkWithSearch) {
                UIApplication.shared.open(deepLinkWithSearch)
                return
            }
            #elseif os(macOS)
            let success = NSWorkspace.shared.open(deepLinkWithSearch)
            if success {
                return
            }
            #endif
        }
        
        // Try with basic deep linking if search didn't work
        if let deepLinkURL = provider.appDeepLinkURL {
            #if os(iOS)
            if UIApplication.shared.canOpenURL(deepLinkURL) {
                UIApplication.shared.open(deepLinkURL)
                return
            }
            #elseif os(macOS)
            let success = NSWorkspace.shared.open(deepLinkURL)
            if success {
                return
            }
            #endif
        }
        
        // If deep linking fails, fall back to web URL with search when possible
        if let webURL = getWebURLWithSearch(provider: provider, encodedTitle: encodedTitle) {
            #if os(iOS)
            UIApplication.shared.open(webURL)
            #elseif os(macOS)
            NSWorkspace.shared.open(webURL)
            #endif
        } else if let webURL = provider.webURL {
            // Just use the regular web URL if we can't do a search
            #if os(iOS)
            UIApplication.shared.open(webURL)
            #elseif os(macOS)
            NSWorkspace.shared.open(webURL)
            #endif
        }
    }
    
    private func getDeepLinkWithSearch(provider: StreamingProvider, encodedTitle: String) -> URL? {
        switch provider.providerName {
        case "Netflix":
            return URL(string: "netflix://search?q=\(encodedTitle)")
        case "Disney Plus":
            return URL(string: "disneyplus://search?q=\(encodedTitle)")
        case "Apple TV", "Apple TV+":
            return URL(string: "videos://search?q=\(encodedTitle)")
        case "Amazon Prime Video":
            return URL(string: "aiv://search?q=\(encodedTitle)")
        case "Hulu":
            return URL(string: "hulu://search?q=\(encodedTitle)")
        case "Max":
            return URL(string: "hbomax://search?q=\(encodedTitle)")
        default:
            return nil
        }
    }
    
    private func getWebURLWithSearch(provider: StreamingProvider, encodedTitle: String) -> URL? {
        switch provider.providerName {
        case "Netflix":
            return URL(string: "https://www.netflix.com/search?q=\(encodedTitle)")
        case "Disney Plus":
            return URL(string: "https://www.disneyplus.com/search?q=\(encodedTitle)")
        case "Amazon Prime Video":
            return URL(string: "https://www.amazon.com/s?k=\(encodedTitle)&i=instant-video")
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
        default:
            return nil
        }
    }
}