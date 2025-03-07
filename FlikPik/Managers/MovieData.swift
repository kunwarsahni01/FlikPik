//
//  MovieData.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import Foundation
import TMDb

// Simple movie wrapper to avoid extending TMDb.Movie directly
struct SimpleMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let runtime: Int?
    let releaseDate: Date?
    let posterPath: String?
    let backdropPath: String?
    
    init(from movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview ?? ""
        self.runtime = movie.runtime
        self.releaseDate = movie.releaseDate
        self.posterPath = movie.posterPath?.absoluteString
        self.backdropPath = movie.backdropPath?.absoluteString
    }
}

struct MovieData: Identifiable, Codable {
    let movie: Movie
    let backdropURL: URL?
    let posterURL: URL?
    let logoURL: URL?
    var streamingProviders: [StreamingProvider]?
    var castMembers: [CastMember]?
    
    var id: Int {
        movie.id
    }
    
    // Standard initializer
    init(movie: Movie, backdropURL: URL?, posterURL: URL?, logoURL: URL?, 
         streamingProviders: [StreamingProvider]? = nil, castMembers: [CastMember]? = nil) {
        self.movie = movie
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.logoURL = logoURL
        self.streamingProviders = streamingProviders
        self.castMembers = castMembers
    }
    
    // For persistence, we only need to save essential data
    enum CodingKeys: String, CodingKey {
        case simpleMovie, backdropURL, posterURL, logoURL
    }
    
    // Custom encoding to use SimpleMovie
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Convert Movie to SimpleMovie for encoding
        let simpleMovie = SimpleMovie(from: movie)
        try container.encode(simpleMovie, forKey: .simpleMovie)
        
        // Encode URLs as strings to ensure they're properly saved
        let backdropURLString = backdropURL?.absoluteString
        let posterURLString = posterURL?.absoluteString
        let logoURLString = logoURL?.absoluteString
        
        try container.encodeIfPresent(backdropURLString, forKey: .backdropURL)
        try container.encodeIfPresent(posterURLString, forKey: .posterURL) 
        try container.encodeIfPresent(logoURLString, forKey: .logoURL)
        
        // Debug: Print the URLs we're encoding
        #if DEBUG
        print("Encoding movie \(movie.id) with posterURL: \(String(describing: posterURLString))")
        #endif
    }
    
    // Custom decoding to convert SimpleMovie back to Movie
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode SimpleMovie
        let simpleMovie = try container.decode(SimpleMovie.self, forKey: .simpleMovie)
        
        // Create Movie from SimpleMovie
        let movie = Movie(
            id: simpleMovie.id,
            title: simpleMovie.title,
            overview: simpleMovie.overview,
            runtime: simpleMovie.runtime,
            releaseDate: simpleMovie.releaseDate,
            posterPath: simpleMovie.posterPath != nil ? URL(string: simpleMovie.posterPath!) : nil,
            backdropPath: simpleMovie.backdropPath != nil ? URL(string: simpleMovie.backdropPath!) : nil
        )
        
        // Decode URL strings and convert them to URLs
        let backdropURLString = try container.decodeIfPresent(String.self, forKey: .backdropURL)
        let posterURLString = try container.decodeIfPresent(String.self, forKey: .posterURL)
        let logoURLString = try container.decodeIfPresent(String.self, forKey: .logoURL)
        
        // Convert strings to URLs
        let backdropURL = backdropURLString != nil ? URL(string: backdropURLString!) : nil
        let posterURL = posterURLString != nil ? URL(string: posterURLString!) : nil
        let logoURL = logoURLString != nil ? URL(string: logoURLString!) : nil
        
        // Initialize properties
        self.movie = movie
        self.backdropURL = backdropURL
        self.posterURL = posterURL
        self.logoURL = logoURL
        self.streamingProviders = nil
        self.castMembers = nil
        
        // Debug: Print the URLs we're decoding
        #if DEBUG
        print("Decoded movie \(movie.id) with posterURL: \(String(describing: posterURL))")
        print("Original string was: \(String(describing: posterURLString))")
        #endif
    }
}

struct StreamingProvider: Identifiable, Codable {
    let id: Int
    let providerName: String
    let providerLogoURL: URL
}

struct CastMember: Identifiable, Codable {
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
