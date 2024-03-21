//
//  NetworkServiceTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

@testable import BANQUEMISR
import XCTest
import Combine

class NetworkServiceTests: XCTestCase {
	let apiKeyProvider = KeychainAPIKeyProvider()
	
	func testGetRequest_NetworkError() {
		// Given
		let service = NetworkService.shared
		let path = "/nonexistentendpoint" // Endpoint that does not exist
		
		// When
		let publisher: AnyPublisher<String, Error> = service.getRequest(from: path)
		
		// Then
		let expectation = XCTestExpectation(description: "Fetch request failed due to network error")
		var receivedError: Error?
		
		let cancellable = publisher
			.sink(
				receiveCompletion: { completion in
					switch completion {
						case .finished:
							XCTFail("Unexpected successful completion")
						case .failure(let error):
							receivedError = error
							expectation.fulfill()
					}
				},
				receiveValue: { _ in }
			)
		
		wait(for: [expectation], timeout: 5.0)
		
		XCTAssertNotNil(receivedError)
		
		cancellable.cancel()
	}
}
