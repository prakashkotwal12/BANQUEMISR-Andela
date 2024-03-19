//
//  Movie.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

// MARK: - Movie Model
struct Movie: Codable {
	let id: Int
	let title: String
	let overview: String
	let backdropPath: String?
	let genreIds: [Int]
	let originalLanguage, originalTitle: String
	let popularity: Double
	let posterPath: String?
	let releaseDate: String
	let video: Bool
	let voteAverage: Double
	let voteCount: Int
	
	enum CodingKeys: String, CodingKey {
		case id, title, overview
		case backdropPath = "backdrop_path"
		case genreIds = "genre_ids"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case popularity
		case posterPath = "poster_path"
		case releaseDate = "release_date"
		case video
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}
}
