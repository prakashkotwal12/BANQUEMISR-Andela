//
//  ProductionCompanyTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//
import XCTest
@testable import BANQUEMISR

class ProductionCompanyTests: XCTestCase {
	func testDecodeFromJSON() {
		// Given
		let json = """
		{
			"id": 1,
			"logo_path": "/logo.jpg",
			"name": "Production Company",
			"origin_country": "US"
		}
		""".data(using: .utf8)!
		
		// When
		let decoder = JSONDecoder()
		do {
			let productionCompany = try decoder.decode(ProductionCompany.self, from: json)
			
			// Then
			XCTAssertEqual(productionCompany.id, 1)
			XCTAssertEqual(productionCompany.logoPath, "/logo.jpg")
			XCTAssertEqual(productionCompany.name, "Production Company")
			XCTAssertEqual(productionCompany.originCountry, "US")
		} catch {
			XCTFail("Failed to decode JSON: \(error)")
		}
	}	
}

