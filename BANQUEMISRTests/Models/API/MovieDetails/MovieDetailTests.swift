//
//  MovieDetailTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//

import XCTest
@testable import BANQUEMISR

class MovieDetailTests: XCTestCase {
	func testDecodeFromJSON() {
		// Given
		let json = """
		{
			"adult": false,
			"backdrop_path": "/backdrop.jpg",
			"belongs_to_collection": null,
			"budget": 10000000,
			"genres": [{"id": 1, "name": "Action"}],
			"homepage": "http://example.com",
			"id": 123,
			"imdb_id": "tt1234567",
			"original_language": "en",
			"original_title": "Original Title",
			"overview": "Movie overview",
			"popularity": 7.5,
			"poster_path": "/poster.jpg",
			"production_companies": [{"id": 1, "name": "Production Company", "origin_country" : "USA"}],
			"production_countries": [{"iso_3166_1": "US", "name": "United States"}],
			"release_date": "2022-01-01",
			"revenue": 50000000,
			"runtime": 120,
			"spoken_languages": [{"english_name": "English", "iso_639_1": "en", "name": "English"}],
			"status": "Released",
			"tagline": "Movie tagline",
			"title": "Movie Title",
			"video": false,
			"vote_average": 7.8,
			"vote_count": 1000
		}
		""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		do {
			let movieDetail = try decoder.decode(MovieDetail.self, from: json)
			
			// Then
			XCTAssertEqual(movieDetail.id, 123)
			XCTAssertEqual(movieDetail.title, "Movie Title")
			XCTAssertEqual(movieDetail.overview, "Movie overview")
			XCTAssertEqual(movieDetail.genres.count, 1)
			XCTAssertEqual(movieDetail.genres[0].name, "Action")
			// Add more assertions for other properties as needed
		} catch {
			XCTFail("Failed to decode JSON: \(error)")
		}
	}
}


