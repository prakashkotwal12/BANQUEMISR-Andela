//
//  MovieViewModelTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
import Combine
@testable import BANQUEMISR

class MovieViewModelTests: XCTestCase {
	
	var viewModel: MovieViewModel!
	var repository: MockMovieRepository!
	var cancellables: Set<AnyCancellable> = []
	
	override func setUp() {
		super.setUp()
		repository = MockMovieRepository()
		viewModel = MovieViewModel(repository: repository)
	}
	
	override func tearDown() {
		viewModel = nil
		repository = nil
		super.tearDown()
	}
	func testFetchNowPlayingMovies_Success() {
		// Given
		let expectedMovies = [Movie(id: 1, title: "Movie 1", overview: "Overview 1", backdropPath: nil, genreIds: [], originalLanguage: "", originalTitle: "", popularity: 0, posterPath: nil, releaseDate: "", video: false, voteAverage: 0, voteCount: 0)]
		repository.moviesResult = .success(expectedMovies) // Assign a Result with success
		
		let expectation = XCTestExpectation(description: "Fetch now playing movies")
		
		// When
		viewModel.$nowPlayingMovies
			.sink { movies in
				// Then
				XCTAssertTrue(movies.allSatisfy { movie in
					expectedMovies.contains { $0.id == movie.id }
				})
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		viewModel.fetchNowPlayingMovies()
		
		wait(for: [expectation], timeout: 1.0)
	}
	
//	func testFetchNowPlayingMovies_Failure() {
//		// Given
//		let expectedError = NSError(domain: "TestDomain", code: 123, userInfo: nil)
//		repository.error = expectedError
//		
//		let expectation = XCTestExpectation(description: "Fetch now playing movies failure")
//		
//		// When
//		viewModel.$error
//			.sink { error in
//				// Then
//				XCTAssertNotNil(error, "Error should not be nil")
//				
//				if let error = error {
//					XCTAssertEqual((error as NSError).code, expectedError.code, "Unexpected error code")
//				}
//				
//				expectation.fulfill()
//			}
//			.store(in: &cancellables)
//		
//		viewModel.fetchNowPlayingMovies()
//		
//		wait(for: [expectation], timeout: 1.0)
//	}
}
// Mock MovieRepository for testing purposes
class MockMovieRepository: MovieRepository {
	var moviesResult: Result<[Movie], Error>?
	var error: Error?
	enum MovieEndpoint {
		case nowPlaying
		// Add other cases if needed
	}
	
	init(moviesResult: Result<[Movie], Error>? = nil) {
		self.moviesResult = moviesResult
		super.init() // Call the superclass initializer
	}
	
	func fetchMovies(_ endpoint: MovieEndpoint) -> AnyPublisher<[Movie], Error> {
		if let moviesResult = moviesResult {
			return Result.Publisher(moviesResult).eraseToAnyPublisher()
		} else if let error = error {
			return Fail(error: error).eraseToAnyPublisher()
		} else {
			fatalError("No result or error provided for testing.")
		}
	}
}
