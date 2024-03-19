//
//  MovieResponse.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

struct MovieResponse: Codable {
	let dates: MovieResponseDates
	let page: Int
	let results: [Movie]	
}
