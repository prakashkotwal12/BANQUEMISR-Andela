//
//  MovieResponse.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

struct MovieResponse: Codable {
	let dates: MovieResponseDates?
	let page: Int
	let results: [Movie]
	let totalPages : Int
	let totalResults : Int
	
	enum CodingKeys: String, CodingKey {
		case dates, page, results
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
}

