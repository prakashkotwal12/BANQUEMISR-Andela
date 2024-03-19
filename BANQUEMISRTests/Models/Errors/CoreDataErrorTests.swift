//
//  CoreDataErrorTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR

class CoreDataErrorTests: XCTestCase {
	
	func testSaveError() {
		// Given
		let underlyingError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Save error description"])
		let coreDataError = CoreDataError.saveError(underlyingError)
		
		// When
		let errorMessage = coreDataError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Save error: Save error description")
	}
	
	func testFetchError() {
		// Given
		let underlyingError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Fetch error description"])
		let coreDataError = CoreDataError.fetchError(underlyingError)
		
		// When
		let errorMessage = coreDataError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Fetch error: Fetch error description")
	}
	
	func testDeleteError() {
		// Given
		let underlyingError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Delete error description"])
		let coreDataError = CoreDataError.deleteError(underlyingError)
		
		// When
		let errorMessage = coreDataError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Delete error: Delete error description")
	}
	
	func testUnknownError() {
		// Given
		let coreDataError = CoreDataError.unknownError
		
		// When
		let errorMessage = coreDataError.errorMessage()
		
		// Then
		XCTAssertEqual(errorMessage, "Unknown error occurred.")
	}	
}
