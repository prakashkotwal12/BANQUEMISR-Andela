//
//  MovieNetworkServiceTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Combine

class MovieNetworkServiceTests: XCTestCase {
	
//	func testFetchMovies_Success() {
//		// Given
//		let service = MovieNetworkService.shared
//		let type: MovieType = .nowPlaying
//		
//		// When
//		let publisher = service.fetchMovies(type)
//		
//		// Then
//		let expectation = XCTestExpectation(description: "Fetch movies successful")
//		var receivedResponse: MovieResponse?
//		
//		let cancellable = publisher
//			.sink(
//				receiveCompletion: { completion in
//					switch completion {
//						case .finished:
//							break
//						case .failure(let error):
//							XCTFail("Unexpected failure: \(error)")
//					}
//					expectation.fulfill()
//				},
//				receiveValue: { response in
//					receivedResponse = response
//				}
//			)
//		
//		wait(for: [expectation], timeout: 5.0)
//		
//		XCTAssertNotNil(receivedResponse)
//		XCTAssertFalse(receivedResponse?.results.isEmpty ?? true)
//		cancellable.cancel()
//	}
	
//	func testFetchMovieDetail_Success() {
//		// Given
//		let service = MovieNetworkService.shared
//		let movieID = 123 // Specify a valid movie ID
//		
//		// When
//		let publisher = service.fetchMovieDetail(movieID: movieID)
//		
//		// Then
//		let expectation = XCTestExpectation(description: "Fetch movie detail successful")
//		var receivedMovie: Movie?
//		
//		let cancellable = publisher
//			.sink(
//				receiveCompletion: { completion in
//					switch completion {
//						case .finished:
//							break
//						case .failure(let error):
//							XCTFail("Unexpected failure: \(error)")
//					}
//					expectation.fulfill()
//				},
//				receiveValue: { movie in
//					receivedMovie = movie
//				}
//			)
//		
//		wait(for: [expectation], timeout: 5.0)
//		
//		XCTAssertNotNil(receivedMovie)
//		XCTAssertEqual(receivedMovie?.id, movieID)
//		cancellable.cancel()
//	}
}

