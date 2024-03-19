//
//  ErrorResponseTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR
class ErrorResponseTests: XCTestCase {
	
	func testEncodeDecode() throws {
		// Given
		let errorResponse = ErrorResponse(statusCode: 404, statusMessage: "Not found", success: false)
		
		// When
		let encoder = JSONEncoder()
		let jsonData = try encoder.encode(errorResponse)
		
		let decoder = JSONDecoder()
		let decodedErrorResponse = try decoder.decode(ErrorResponse.self, from: jsonData)
		
		// Then
		XCTAssertEqual(decodedErrorResponse.statusCode, errorResponse.statusCode)
		XCTAssertEqual(decodedErrorResponse.statusMessage, errorResponse.statusMessage)
		XCTAssertEqual(decodedErrorResponse.success, errorResponse.success)
	}	
}
