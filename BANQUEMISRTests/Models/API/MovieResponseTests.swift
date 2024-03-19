//
//  MovieResponseTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR

class MovieResponseTests: XCTestCase {
	
	func testDecoding() throws {
		// Given
		let json = """
		{
			"dates": {
				"maximum": "2024-03-20",
				"minimum": "2024-03-18"
			},
			"page": 1,
			"results": [
				{
					"id": 123,
					"title": "Movie Title",
					"overview": "Movie overview",
					"backdrop_path": "/path/to/backdrop",
					"genre_ids": [12, 34],
					"original_language": "en",
					"original_title": "Original Title",
					"popularity": 7.8,
					"poster_path": "/path/to/poster",
					"release_date": "2024-03-19",
					"video": false,
					"vote_average": 7.5,
					"vote_count": 100
				}
			]
		}
		""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		let movieResponse = try decoder.decode(MovieResponse.self, from: json)
		
		// Then
		XCTAssertEqual(movieResponse.page, 1)
		XCTAssertEqual(movieResponse.dates.maximum, "2024-03-20")
		XCTAssertEqual(movieResponse.dates.minimum, "2024-03-18")
		XCTAssertEqual(movieResponse.results.count, 1)
		XCTAssertEqual(movieResponse.results[0].id, 123)
		XCTAssertEqual(movieResponse.results[0].title, "Movie Title")
		XCTAssertEqual(movieResponse.results[0].overview, "Movie overview")
		XCTAssertEqual(movieResponse.results[0].backdropPath, "/path/to/backdrop")
		XCTAssertEqual(movieResponse.results[0].genreIds, [12, 34])
		XCTAssertEqual(movieResponse.results[0].originalLanguage, "en")
		XCTAssertEqual(movieResponse.results[0].originalTitle, "Original Title")
		XCTAssertEqual(movieResponse.results[0].popularity, 7.8)
		XCTAssertEqual(movieResponse.results[0].posterPath, "/path/to/poster")
		XCTAssertEqual(movieResponse.results[0].releaseDate, "2024-03-19")
		XCTAssertEqual(movieResponse.results[0].video, false)
		XCTAssertEqual(movieResponse.results[0].voteAverage, 7.5)
		XCTAssertEqual(movieResponse.results[0].voteCount, 100)
	}	
}
