//
//  SpokenLanguageTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//
import XCTest
@testable import BANQUEMISR

class SpokenLanguageTests: XCTestCase {
	func testDecodeFromJSON() {
		// Given
		let json = """
		{
			"english_name": "English",
			"iso_639_1": "en",
			"name": "English"
		}
		""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		do {
			let spokenLanguage = try decoder.decode(SpokenLanguage.self, from: json)
			
			// Then
			XCTAssertEqual(spokenLanguage.englishName, "English")
			XCTAssertEqual(spokenLanguage.iso_639_1, "en")
			XCTAssertEqual(spokenLanguage.name, "English")
		} catch {
			XCTFail("Failed to decode JSON: \(error)")
		}
	}	
}

