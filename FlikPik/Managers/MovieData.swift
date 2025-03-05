//
//  MovieData.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import Foundation
import TMDb

struct MovieData {
    let movie: Movie
    let backdropURL: URL
    let posterURL: URL
    let logoURL: URL?
    var streamingProviders: [StreamingProvider]?
    var castMembers: [CastMember]?
}

struct StreamingProvider: Identifiable {
    let id: Int
    let providerName: String
    let providerLogoURL: URL
    
    // Deep linking URL scheme
    var appDeepLinkURL: URL? {
        switch providerName {
        case "Netflix":
            return URL(string: "netflix://")
        case "Disney Plus":
            return URL(string: "disneyplus://")
        case "Apple TV":
            return URL(string: "videos://")
        case "Apple TV+":
            return URL(string: "videos://")
        case "Amazon Prime Video":
            return URL(string: "aiv://")
        case "Hulu":
            return URL(string: "hulu://")
        case "Max":
            return URL(string: "hbomax://")
        case "Peacock":
            return URL(string: "peacock://")
        case "Paramount+":
            return URL(string: "paramountplus://")
        default:
            return nil
        }
    }
    
    // Web URL as fallback
    var webURL: URL? {
        switch providerName {
        case "Netflix":
            return URL(string: "https://www.netflix.com")
        case "Disney Plus":
            return URL(string: "https://www.disneyplus.com")
        case "Apple TV", "Apple TV+":
            return URL(string: "https://tv.apple.com")
        case "Amazon Prime Video":
            return URL(string: "https://www.amazon.com/Prime-Video")
        case "Hulu":
            return URL(string: "https://www.hulu.com")
        case "Max":
            return URL(string: "https://www.max.com")
        case "Peacock":
            return URL(string: "https://www.peacocktv.com")
        case "Paramount+":
            return URL(string: "https://www.paramountplus.com")
        default:
            return nil
        }
    }
}

struct CastMember {
    let id: Int
    let name: String
    let character: String
    let profileURL: URL?
}

let moviePosterURLPrefix = URL(string: "https://image.tmdb.org/t/p")!

enum TMDBImageSize:String {
    case w300 = "/w300"
    case w1280 = "/w1280"
    case original = "/original"
}

func imageBaseURL(_ size:TMDBImageSize) -> URL {
    moviePosterURLPrefix.appending(path: size.rawValue)
}

let baseURL = imageBaseURL(.w300)
let bigSizeBaseURL = imageBaseURL(.w1280)
let originalSizeBaseURL = imageBaseURL(.original)
