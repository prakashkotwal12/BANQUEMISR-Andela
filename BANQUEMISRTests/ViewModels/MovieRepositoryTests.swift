//
//  MovieRepositoryTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
import Combine
@testable import BANQUEMISR

class MovieRepositoryTests: XCTestCase {
	
	// Create a Mock MovieServiceProtocol for testing purposes
	class MockMovieService: MovieServiceProtocol {
		func fetchMovies(_ type: MovieType) -> AnyPublisher<MovieResponse, Error> {
			// Simulate a successful response with dummy data
			let dummyResponse = MovieResponse(dates: MovieResponseDates(maximum: "2024-12-31", minimum: "2024-01-01"), page: 1, results: [])
			return Just(dummyResponse)
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
	}
	
	// Create a Mock MovieDataManager for testing purposes
	class MockMovieDataManager: MovieDataManager {
		override init() {
			super.init()
			
		}
		
		override func saveMovies(_ movies: [Movie]) -> AnyPublisher<Void, Error> {
			// Simulate successful saving of movies
			return Just(())
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		}
	}
	
	var cancellables = Set<AnyCancellable>()
	var repository: MovieRepository!
	
	override func setUp() {
		super.setUp()
		// Initialize the repository with mock dependencies
		repository = MovieRepository(networkService: MockMovieService(), dataManager: MockMovieDataManager())
	}
	
	override func tearDown() {
		repository = nil
		super.tearDown()
	}
	
	func testFetchMovies_Success() {
		// Given
		let expectation = XCTestExpectation(description: "Fetch movies")
		
		// When
		let publisher = repository.fetchMovies(.nowPlaying)
		
		// Then
		publisher.sink(receiveCompletion: { completion in
			switch completion {
				case .finished:
					// Ensure the completion is successful
					break
				case .failure(let error):
					XCTFail("Fetching movies failed with error: \(error)")
			}
			expectation.fulfill()
		}, receiveValue: { movies in
			// Ensure movies are received
			XCTAssertNotNil(movies)
		}).store(in: &cancellables)
		
		wait(for: [expectation], timeout: 1.0)
	}
}

