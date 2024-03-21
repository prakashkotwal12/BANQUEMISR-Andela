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
	
	// MARK: - Mock Movie Repository
	
	
	// MARK: - Test Cases
	
	func testFetchMoviesSuccess() {
		// Given
		let viewModel = MovieViewModel(repository: MockMovieRepository())
		
		let movieResponse = MovieResponse(
			dates: nil, page: 1,
			results: [Movie](), // Add mock movies here for testing
			totalPages: 1,
			totalResults: 0
		)
		
		(viewModel.repository as? MockMovieRepository)?.movieResponse = movieResponse
		
		// When
		viewModel.fetchNextMovie(for: .nowPlaying)
		
		// Then
		XCTAssertTrue(viewModel.movies.isEmpty)
		XCTAssertNil(viewModel.error)
	}
	
	func testFetchMoviesFailure() {
		// Given
		let viewModel = MovieViewModel(repository: MockMovieRepository())
		let expectedError = MovieError.localError(NSError(domain: "", code: 0, userInfo: nil))
		(viewModel.repository as? MockMovieRepository)?.error = expectedError
		
		// When
		viewModel.fetchNextMovie(for: .nowPlaying)
		
		// Then
		XCTAssertNotNil(viewModel.error)
		XCTAssertTrue(viewModel.movies.isEmpty)
	}
	
}

class MockMovieRepository: MovieRepository {
	var movieResponse: MovieResponse?
	var error: Error?
	
	// Provide an initializer
	init() {
		super.init()
	}
	
	override func fetchMovies(_ type: MovieType, page: Int) -> AnyPublisher<MovieResponse, Error> {
		if let movieResponse = movieResponse {
			return Just(movieResponse)
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		} else if let error = error {
			return Fail(error: error)
				.eraseToAnyPublisher()
		} else {
			fatalError("You need to set either movieResponse or error for testing purposes.")
		}
	}	
}
class MockMovieDetailRepository: MovieRepository {
	var movieDetail: MovieDetail?
	var error: Error?
	
	// Provide an initializer
	init(mDetail : MovieDetail) {
		super.init()
		self.movieDetail = mDetail
	}
	
	override func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error> {
		if let movieResponse = movieDetail {
			return Just(movieDetail!)
				.setFailureType(to: Error.self)
				.eraseToAnyPublisher()
		} else if let error = error {
			return Fail(error: error)
				.eraseToAnyPublisher()
		} else {
			fatalError("You need to set either movieResponse or error for testing purposes.")
		}
	}
}
