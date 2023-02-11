//
//  MovieResponse.swift
//  CloneNetflix
//
//  Created by Đức Anh Trần on 04/01/2023.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Movie: Codable {
    let id: Int
    let backdropPath: String?
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let mediaType: String?
    let releaseDate: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title, overview, name
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
