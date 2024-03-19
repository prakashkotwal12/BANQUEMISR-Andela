//
//  MovieResponseDatesTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR

class MovieResponseDatesTests: XCTestCase {
	
	func testEncodeDecode() throws {
		// Given
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [.withFullDate]
		
		if let maximumDate = dateFormatter.date(from: "2024-12-31"),
			 let minimumDate = dateFormatter.date(from: "2024-01-01") {
			let dates = MovieResponseDates(maximum: dateFormatter.string(from: maximumDate),
																		 minimum: dateFormatter.string(from: minimumDate))
			
			// When
			let encoder = JSONEncoder()
			let jsonData = try encoder.encode(dates)
			
			let decoder = JSONDecoder()
			let decodedDates = try decoder.decode(MovieResponseDates.self, from: jsonData)
			
			// Then
			XCTAssertEqual(decodedDates.maximum, dates.maximum)
			XCTAssertEqual(decodedDates.minimum, dates.minimum)
		} else {
			XCTFail("Failed to create dates.")
		}
	}	
}
