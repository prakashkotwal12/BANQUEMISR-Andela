//
//  SpokenLanguage.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

struct SpokenLanguage: Codable {
	let englishName: String
	let iso_639_1: String
	let name: String
	enum CodingKeys: String, CodingKey {
		case englishName = "english_name"
		case iso_639_1, name
	}	
}
