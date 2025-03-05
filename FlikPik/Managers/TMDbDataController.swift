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
    
    // Structure to hold search results
    struct MovieSearchResult: Identifiable {
        let id: Int
        let title: String
        let overview: String
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
            
            // Filter for English language images or no specified language (null)
            // And sort by vote count to get the highest quality images
            
            // Process backdrops - filter by language and sort by vote count (highest first)
//            let filteredBackdrops = imageURLs.backdrops.filter { 
//                $0.languageCode == "en" || $0.languageCode == nil
//            }.sorted(by: { 
//                // Handle optional vote counts by providing default values (0) for nil
//                let vote1 = $0.voteCount ?? 0
//                let vote2 = $1.voteCount ?? 0
//                return vote1 > vote2
//            })
            let filteredBackdrops = imageURLs.backdrops
            
            // Process posters - filter by language and sort by vote count (highest first)
            let filteredPosters = imageURLs.posters.filter { 
                $0.languageCode == "en" || $0.languageCode == nil
            }.sorted(by: { 
                let vote1 = $0.voteCount ?? 0
                let vote2 = $1.voteCount ?? 0
                return vote1 > vote2
            })
            
            // Process logos - filter by language and sort by vote count (highest first)
            let filteredLogos = imageURLs.logos.filter { 
                $0.languageCode == "en" || $0.languageCode == nil
            }.sorted(by: { 
                let vote1 = $0.voteCount ?? 0
                let vote2 = $1.voteCount ?? 0
                return vote1 > vote2
            })
            
            // Safely get backdrop URL or use nil - prioritize English, highest voted
            var backdropURL: URL? = nil
            if !filteredBackdrops.isEmpty {
                let backdrop = filteredBackdrops[0].filePath.absoluteString
                backdropURL = originalSizeBaseURL.appending(path: backdrop)
            } else if !imageURLs.backdrops.isEmpty {
                // Fallback to any language if no English backdrops
                let backdrop = imageURLs.backdrops.sorted(by: { 
                    let vote1 = $0.voteCount ?? 0
                    let vote2 = $1.voteCount ?? 0
                    return vote1 > vote2
                })[0].filePath.absoluteString
                backdropURL = originalSizeBaseURL.appending(path: backdrop)
            }
            
            // Safely get poster URL or use nil - prioritize English, highest voted
            var posterURL: URL? = nil
            if !filteredPosters.isEmpty {
                let poster = filteredPosters[0].filePath.absoluteString
                posterURL = originalSizeBaseURL.appending(path: poster)
            } else if !imageURLs.posters.isEmpty {
                // Fallback to any language if no English posters
                let poster = imageURLs.posters.sorted(by: { 
                    let vote1 = $0.voteCount ?? 0
                    let vote2 = $1.voteCount ?? 0
                    return vote1 > vote2
                })[0].filePath.absoluteString
                posterURL = originalSizeBaseURL.appending(path: poster)
            } else if let posterPath = movie.posterPath?.absoluteString {
                // Final fallback to the poster from the movie details if available
                posterURL = originalSizeBaseURL.appending(path: posterPath)
            }
            
            // Safely get logo URL or use nil - prioritize English, highest voted
            var logoURL: URL? = nil
            if !filteredLogos.isEmpty {
                let logo = filteredLogos[0].filePath.absoluteString
                logoURL = originalSizeBaseURL.appending(path: logo)
            } else if !imageURLs.logos.isEmpty {
                // Fallback to any language if no English logos
                let logo = imageURLs.logos.sorted(by: { 
                    let vote1 = $0.voteCount ?? 0
                    let vote2 = $1.voteCount ?? 0
                    return vote1 > vote2
                })[0].filePath.absoluteString
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
                        
            // Collect providers from all available categories (free, flatRate, buy, rent)
            var allProviders = [WatchProvider]()
            
            // Add free providers if available
            if let freeProviders = watchProviders?.free {
                allProviders.append(contentsOf: freeProviders)
            }
            
            // Add flat rate providers if available
            if let flatRateProviders = watchProviders?.flatRate {
                allProviders.append(contentsOf: flatRateProviders)
            }
            
            // Add buy providers if available
            if let buyProviders = watchProviders?.buy {
                allProviders.append(contentsOf: buyProviders)
            }
            
            // Add rent providers if available
            if let rentProviders = watchProviders?.rent {
                allProviders.append(contentsOf: rentProviders)
            }
            
            // Return nil if no providers are available
            guard !allProviders.isEmpty else {
                return nil
            }
            
            // Filter out unwanted providers (Google Play, Microsoft Store, Fandango)
            let filteredProviders = allProviders.filter { provider in
                let name = provider.name.lowercased()
                return !name.contains("google play") && 
                       !name.contains("microsoft") && 
                       !name.contains("fandango")
            }
            
            // Return nil if all providers were filtered out
            guard !filteredProviders.isEmpty else {
                return nil
            }
            
            // Remove duplicates by creating a dictionary keyed by provider ID
            var uniqueProviders = [Int: WatchProvider]()
            for provider in filteredProviders {
                uniqueProviders[provider.id] = provider
            }
            
            // Convert to our StreamingProvider model
            return uniqueProviders.values.map { provider in
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
    
    func searchMovies(query: String) async -> [MovieSearchResult]? {
        // Don't search if query is empty or too short
        guard !query.isEmpty, query.count >= 2 else {
            return nil
        }
        
        do {
            // Search for movies matching the query
            let searchResults = try await tmdbClient.search.searchMovies(query: query)
            
            // Map search results to our MovieSearchResult structure
            let movies = searchResults.results.map { movie in
                let posterPath = movie.posterPath?.absoluteString
                let posterURL = posterPath != nil ? baseURL.appending(path: posterPath!) : nil
                
                return MovieSearchResult(
                    id: movie.id,
                    title: movie.title,
                    overview: movie.overview,
                    posterURL: posterURL,
                    releaseDate: movie.releaseDate
                )
            }
            
            // Always return an array, even if empty, to distinguish between no results and error
            return movies
        } catch {
            print("Failed to search movies")
            print(error.localizedDescription)
            return []
        }
    }
}
