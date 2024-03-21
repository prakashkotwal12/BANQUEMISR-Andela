//
//  BelongsToCollection.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

struct BelongsToCollection: Codable {
	let id: Int
	let name: String
	let posterPath: String?
	let backdropPath: String?
	enum CodingKeys: String, CodingKey {
		case id, name
		case posterPath = "poster_path"
		case backdropPath = "backdrop_path"
	}	
}
