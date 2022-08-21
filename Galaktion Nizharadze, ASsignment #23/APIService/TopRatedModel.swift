//
//  TopRatedModel.swift
//  Galaktion Nizharadze, ASsignment #23
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import Foundation

import Foundation

// MARK: - UniónDeNacionesSuramericanas
struct TVShows: Codable {
    let results: [Show]
}

// MARK: - Result
struct Show: Codable {
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int
    
    var isFavourite = false

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    
    private var baseURLForImages = "https://image.tmdb.org/t/p/w500"
    var backdropURLString: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")"
    }
    
    var posterURLString: String {
        return  "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0 ..< (rating / 2)).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
}


enum EndPoint {
    case id(String)
    case topRated
    
    var value: String {
        switch self {
        case .topRated:
            return "top_rated"
        case .id(let customValue):
            return customValue
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
