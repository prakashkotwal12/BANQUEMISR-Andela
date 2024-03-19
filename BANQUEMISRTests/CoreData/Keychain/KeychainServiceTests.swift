//
//  KeychainServiceTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Combine

class KeychainServiceTests: XCTestCase {
	
	var keychainService: KeychainService!
	
	override func setUp() {
		super.setUp()
		keychainService = KeychainService.shared
	}
	
	override func tearDown() {
		keychainService = nil
		super.tearDown()
	}
	
	func testLoadAPIKey_Successful() {
		// Given
		let expectation = XCTestExpectation(description: "Load API key from Keychain")
		
		// When
		let publisher: AnyPublisher<String?, Error> = keychainService.loadAPIKey()
		
		// Then
		var receivedAPIKey: String?
		
		let cancellable = publisher
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						break
					case .failure(let error):
						XCTFail("Unexpected failure: \(error)")
				}
				expectation.fulfill()
			}, receiveValue: { apiKey in
				receivedAPIKey = apiKey
			})
		
		wait(for: [expectation], timeout: 5.0)
		
		XCTAssertNotNil(receivedAPIKey)
		
		XCTAssertTrue(receivedAPIKey == "DUMMY_API_KEY" || receivedAPIKey == "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZWIwYTRjMzczNDdjMzk1ZDNlYmY3YmI3MTUxZDBkZSIsInN1YiI6IjY1ZjdkODNjOTAzYzUyMDE2NTI4ODgwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7hm583x3XfD4UEjQHuyW0Et54Hu6-nZo8n1UMq4xaP8")

		
		cancellable.cancel()
	}	
}

