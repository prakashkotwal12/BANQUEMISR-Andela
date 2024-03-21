//
//  ProductionCountryTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//
import XCTest
@testable import BANQUEMISR

class ProductionCountryTests: XCTestCase {
	func testDecodeFromJSON() {
		// Given
		let json = """
	{
	 "iso_3166_1": "US",
	 "name": "United States"
	}
	""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		do {
			let productionCountry = try decoder.decode(ProductionCountry.self, from: json)
			
			// Then
			XCTAssertEqual(productionCountry.iso_3166_1, "US")
			XCTAssertEqual(productionCountry.name, "United States")
		} catch {
			XCTFail("Failed to decode JSON: \(error)")
		}
	}	
}

