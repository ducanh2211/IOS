//
//  Movies.swift
//  MovieAppMVC
//
//  Created by Đức Anh Trần on 02/01/2023.
//

import Foundation

struct MovieModel: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    var backdropPath: String?
    var id: Int
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

}
