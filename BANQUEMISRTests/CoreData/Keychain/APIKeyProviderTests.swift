//
//  APIKeyProviderTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Combine

class APIKeyProviderTests: XCTestCase {
		
		// Mock API key provider conforming to the APIKeyProvider protocol
		class MockAPIKeyProvider: APIKeyProvider {
				var apiKeyResult: AnyPublisher<String?, Error> = Just("DUMMY_API_KEY").setFailureType(to: Error.self).eraseToAnyPublisher()
				
				func getAPIKey() -> AnyPublisher<String?, Error> {
						return apiKeyResult
				}
		}
		
		func testGetAPIKey_Successful() {
				// Given
				let apiKeyProvider = MockAPIKeyProvider()
				let expectation = XCTestExpectation(description: "Retrieve API key successfully")
				
				// When
				let publisher = apiKeyProvider.getAPIKey()
				
				// Then
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
				XCTAssertEqual(receivedAPIKey, "DUMMY_API_KEY")
				XCTAssertNil(receivedError)
				
				cancellable.cancel()
		}
}

