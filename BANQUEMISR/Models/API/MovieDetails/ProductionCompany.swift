//
//  ProductionCompany.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
struct ProductionCompany: Codable {
	let id: Int
	let logoPath: String?
	let name: String
	let originCountry: String
	enum CodingKeys: String, CodingKey {
		case id, name
		case logoPath = "logo_path"
		case originCountry = "origin_country"
	}	
}
