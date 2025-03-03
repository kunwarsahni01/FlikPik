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
}

struct StreamingProvider {
    let providerName: String
    let providerLogoURL: URL
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
