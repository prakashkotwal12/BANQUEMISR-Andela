//
//  MovieDetail.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
struct MovieDetail: Codable {
	let adult: Bool
	let backdropPath: String?
	let belongsToCollection: BelongsToCollection?
	let budget: Double
	let genres: [Genre]
	let homepage: String?
	let id: Int
	let imdbID: String
	let originalLanguage: String
	let originalTitle: String
	let overview: String
	let popularity: Double
	let posterPath: String?
	let productionCompanies: [ProductionCompany]
	let productionCountries: [ProductionCountry]
	let releaseDate: String
	let revenue: Int
	let runtime: Int
	let spokenLanguages: [SpokenLanguage]
	let status: String
	let tagline: String?
	let title: String
	let video: Bool
	let voteAverage: Double
	let voteCount: Int
	
	enum CodingKeys: String, CodingKey {
		case adult
		case backdropPath = "backdrop_path"
		case belongsToCollection = "belongs_to_collection"
		case budget
		case genres
		case homepage
		case id
		case imdbID = "imdb_id"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case overview
		case popularity
		case posterPath = "poster_path"
		case productionCompanies = "production_companies"
		case productionCountries = "production_countries"
		case releaseDate = "release_date"
		case revenue
		case runtime
		case spokenLanguages = "spoken_languages"
		case status
		case tagline
		case title
		case video
		case voteAverage = "vote_average"
		case voteCount = "vote_count"
	}	
}
