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
    
    // Structure to hold actor filmography data
    struct ActorMovie: Identifiable {
        let id: Int
        let title: String
        var character: String
        let posterURL: URL?
        let releaseDate: Date?
    }


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
            
            // Safely get backdrop URL or use nil
            var backdropURL: URL? = nil
            if !imageURLs.backdrops.isEmpty {
                let backdrop = imageURLs.backdrops[0].filePath.absoluteString
                backdropURL = originalSizeBaseURL.appending(path: backdrop)
            }
            
            // Safely get poster URL or use nil
            var posterURL: URL? = nil
            if !imageURLs.posters.isEmpty {
                let poster = imageURLs.posters[0].filePath.absoluteString
                posterURL = originalSizeBaseURL.appending(path: poster)
            } else if let posterPath = movie.posterPath?.absoluteString {
                // Fallback to the poster from the movie details if available
                posterURL = originalSizeBaseURL.appending(path: posterPath)
            }
            
            // Safely get logo URL or use nil
            var logoURL: URL? = nil
            if !imageURLs.logos.isEmpty {
                let logo = imageURLs.logos[0].filePath.absoluteString
                logoURL = originalSizeBaseURL.appending(path: logo)
            }
            
            // Create movie data without streaming providers and cast
            var movieData = MovieData(
                movie: movie, 
                backdropURL: backdropURL, 
                posterURL: posterURL, 
                logoURL: logoURL,
                streamingProviders: nil,
                castMembers: nil
            )
            
            // Fetch streaming providers and update movie data
            if let providers = await fetchStreamingProviders(forMovieId: id) {
                movieData.streamingProviders = providers
            }
            
            // Fetch cast members and update movie data
            if let cast = await fetchCastMembers(forMovieId: id) {
                movieData.castMembers = cast
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
                    id: provider.id,
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
    
    func fetchCastMembers(forMovieId id: Int) async -> [CastMember]? {
        do {
            // Using the TMDb client to fetch credits which include cast
            let credits = try await tmdbClient.movies.credits(forMovie: id)
            
            // Get cast members (limit to top 10 for UI purposes)
            let castMembers = credits.cast.prefix(10).map { castMember in
                let profilePath = castMember.profilePath?.absoluteString
                let profileURL = profilePath != nil ? baseURL.appending(path: profilePath!) : nil
                
                return CastMember(
                    id: castMember.id,
                    name: castMember.name,
                    character: castMember.character ?? "Unknown Role",
                    profileURL: profileURL
                )
            }
            
            return castMembers.isEmpty ? nil : Array(castMembers)
        } catch {
            print("Failed to fetch cast members")
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchActorFilmography(actorId: Int) async -> [ActorMovie]? {
        do {
            // Fetch actor details with their movie credits
            let personCredits = try await tmdbClient.people.movieCredits(forPerson: actorId)
            
            // Map the cast entries to our ActorMovie structure
            // Sort by release date (newest first) and limit to 20 movies
            let sortedCredits = personCredits.cast
                .sorted { 
                    // Sort by release date (newest first)
                    guard let date1 = $0.releaseDate, let date2 = $1.releaseDate else {
                        // If either date is nil, prioritize the one with a date
                        return $0.releaseDate != nil && $1.releaseDate == nil
                    }
                    return date1 > date2
                }
                .prefix(20)
            
            // Create array to hold our finished movies with accurate character data
            var movies: [ActorMovie] = []
            
            // Process each movie to get actual character data
            for credit in sortedCredits {
                // Basic info available from credit
                let posterPath = credit.posterPath?.absoluteString
                let posterURL = posterPath != nil ? baseURL.appending(path: posterPath!) : nil
                
                // Create temporary movie with default character value
                var movie = ActorMovie(
                    id: credit.id,
                    title: credit.title,
                    character: "Unknown Role", // Default value
                    posterURL: posterURL,
                    releaseDate: credit.releaseDate
                )
                
                // Fetch accurate character info from the movie's cast list
                if let castMembers = await fetchCastMembers(forMovieId: credit.id) {
                    // Look for this actor in the cast list
                    if let actor = castMembers.first(where: { $0.id == actorId }) {
                        // Update character with accurate data
                        movie.character = actor.character
                    }
                }
                
                movies.append(movie)
            }
            
            return movies.isEmpty ? nil : movies
        } catch {
            print("Failed to fetch actor filmography")
            print(error.localizedDescription)
            return nil
        }
    }
}
