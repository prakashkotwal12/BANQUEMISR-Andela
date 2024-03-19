//
//  MovieErrorTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR

class MovieErrorTests: XCTestCase {
	
	// MARK: - NetworkError
	
	func testNetworkError() {
		// Given
		let underlyingError = NetworkError.invalidURL
		let movieError = MovieError.networkError(underlyingError)
		
		// When
		let errorMessage = movieError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Invalid URL.")
	}
	
	// Test cases for other NetworkError cases
	
	// MARK: - CoreDataError
	
	func testLocalError() {
		// Given
		let underlyingError = CoreDataError.saveError(NSError(domain: "", code: 0, userInfo: nil))
		let movieError = MovieError.localError(underlyingError)
		
		// When
		let errorMessage = movieError.errorMessage()
		
		// Then
		XCTAssertTrue(errorMessage.contains("Save error"), "Error message should contain 'Save error'")
	}
	
	
	// Test cases for other CoreDataError cases
	
	// MARK: - UnknownError
	
	func testUnknownError() {
		// Given
		let movieError = MovieError.unknownError
		
		// When
		let errorMessage = movieError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Unknown error occurred.")
	}	
}

