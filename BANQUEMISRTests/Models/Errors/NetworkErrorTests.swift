//
//  NetworkErrorTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR

class NetworkErrorTests: XCTestCase {
	
	func testErrorMessageForNoInternet() {
		// Given
		let error = NetworkError.noInternet
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "No internet connection.")
	}
	
	func testErrorMessageForInvalidURL() {
		// Given
		let error = NetworkError.invalidURL
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Invalid URL.")
	}
	
	func testErrorMessageForInvalidResponse() {
		let error = NetworkError.invalidResponse
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Invalid server response.")
	}
	
	func testErrorMessageForDecodingError() {
		// Given
		let decodingErrorMessage = "Failed to decode data."
		let decodingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: decodingErrorMessage])
		let error = NetworkError.decodingError(decodingError)
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Decoding error: \(decodingErrorMessage)")
	}
	
	func testErrorMessageForInvalidStatusCode() {
		let statusCode = 404
		let error = NetworkError.invalidStatusCode(statusCode)
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Invalid status code: \(statusCode)")
	}
	
	func testErrorMessageForInvalidAPIKey() {
		let apiKey = "invalidKey"
		let error = NetworkError.invalidAPIKey(apiKey)
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Invalid API key: \(apiKey)")
	}
	
	func testErrorMessageForUnknownError() {
		let error = NetworkError.unknownError
		
		// When
		let errorMessage = error.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Unknown error occurred.")
	}	
}

