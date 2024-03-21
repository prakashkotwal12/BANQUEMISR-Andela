//
//  GenreTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//

import XCTest
@testable import BANQUEMISR

class GenreTests: XCTestCase {
	func testDecodeFromJSON() {
		// Given
		let json = """
		{
			"id": 1,
			"name": "Action"
		}
		""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		do {
			let genre = try decoder.decode(Genre.self, from: json)
			
			// Then
			XCTAssertEqual(genre.id, 1)
			XCTAssertEqual(genre.name, "Action")
		} catch {
			XCTFail("Failed to decode JSON: \(error)")
		}
	}
}
