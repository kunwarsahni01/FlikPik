//
//  TMDbDataController.swift
//  FlikPik
//
//  Created by Kunwar Sahni on 3/3/25.
//

import Foundation
import TMDb

@Observable
class TMDbDataController {
    private let tmdbClient = TMDbClient(apiKey: "4ecabf108260aecf3aa547248da6a35d")


    init() {
        do {

        } catch {
            // do nothing
        }
    }
    
    func getMovie(id: Int) async -> MovieData? {
        do {
            let movie = try await tmdbClient.movies.details(forMovie: id)
            let imageURLs = try await tmdbClient.movies.images(forMovie: id)
            
            let backdrop = imageURLs.backdrops[0].filePath.absoluteString
            let backdropURL = originalSizeBaseURL.appending(path: backdrop)
            
            let poster = imageURLs.posters[0].filePath.absoluteString
            let posterURL = originalSizeBaseURL.appending(path: poster)
            
            let logo = imageURLs.logos[0].filePath.absoluteString
            let logoURL = originalSizeBaseURL.appending(path: logo)
            
            // Create movie data without streaming providers
            var movieData = MovieData(
                movie: movie, 
                backdropURL: backdropURL, 
                posterURL: posterURL, 
                logoURL: logoURL,
                streamingProviders: nil
            )
            
            // Fetch streaming providers and update movie data
            if let providers = await fetchStreamingProviders(forMovieId: id) {
                movieData.streamingProviders = providers
            }

            return movieData
        } catch {
            print("Unable to get data")
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchStreamingProviders(forMovieId id: Int) async -> [StreamingProvider]? {
        do {
            // Using the TMDb client to fetch watch providers
            let watchProviders = try await tmdbClient.movies.watchProviders(forMovie: id)
            
            // Get US providers if available (or whatever locale needed)
            guard let usProviders = watchProviders?.buy else {
                return nil
            }
            
            // Convert to our StreamingProvider model
            return usProviders.map { provider in
                let logoPath = provider.logoPath?.absoluteString ?? ""
                let providerLogoURL = baseURL.appending(path: logoPath)
                
                return StreamingProvider(
                    providerName: provider.name,
                    providerLogoURL: providerLogoURL
                )
            }
        } catch {
            print("Failed to fetch streaming providers")
            print(error.localizedDescription)
            return nil
        }
    }
}
