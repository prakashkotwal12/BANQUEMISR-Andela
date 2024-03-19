//
//  KeychainAPIKeyProviderTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Combine

class KeychainAPIKeyProviderTests: XCTestCase {
	
	func testGetAPIKey_Successful() {
		// Given
		let keychainService = KeychainService.shared
		let apiKeyKey = "com.ANDELA.BANQUEMISR"
		let hardcodedAPIKey = "DUMMY_API_KEY"
		let mockApiKeyProvider = KeychainAPIKeyProvider()
		
		// Save a hardcoded API key to Keychain for testing
		let saveExpectation = XCTestExpectation(description: "API key saved to Keychain")
		let data = hardcodedAPIKey.data(using: .utf8)!
		do {
			try keychainService.save(apiKeyKey, data: data)
			saveExpectation.fulfill()
		} catch {
			XCTFail("Failed to save API key to Keychain: \(error)")
		}
		wait(for: [saveExpectation], timeout: 5.0)
		
		// When
		let publisher = mockApiKeyProvider.getAPIKey()
		
		// Then
		let expectation = XCTestExpectation(description: "Retrieve API key successfully")
		var receivedAPIKey: String?
		var receivedError: Error?
		
		let cancellable = publisher
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						break
					case .failure(let error):
						receivedError = error
						expectation.fulfill()
				}
			}, receiveValue: { apiKey in
				receivedAPIKey = apiKey
				expectation.fulfill()
			})
		
		wait(for: [expectation], timeout: 5.0)
		
		XCTAssertNotNil(receivedAPIKey)
		XCTAssertEqual(receivedAPIKey, hardcodedAPIKey)
		XCTAssertNil(receivedError)
		
		cancellable.cancel()
	}	
}

