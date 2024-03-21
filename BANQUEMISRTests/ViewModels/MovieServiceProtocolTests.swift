//
//  MovieServiceProtocolTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import XCTest
import Combine
@testable import BANQUEMISR
// Define a mock movie service conforming to MovieServiceProtocol
class MockMovieService: MovieServiceProtocol {
	var moviesResult: Result<MovieResponse, Error>?
	
	func fetchMovies(_ type: MovieType) -> AnyPublisher<MovieResponse, Error> {
		if let result = moviesResult {
			return Result.Publisher(result).eraseToAnyPublisher()
		} else {
			return Fail(error: NSError(domain: "MockMovieServiceError", code: 404, userInfo: nil)).eraseToAnyPublisher()
		}
	}	
}

class MovieServiceTests: XCTestCase {
	var movieService: MockMovieService!
	var cancellables: Set<AnyCancellable> = []
	
	override func setUp() {
		super.setUp()
		movieService = MockMovieService()
	}
	
	override func tearDown() {
		movieService = nil
		super.tearDown()
	}
	
//	func testFetchMovies_Success() {
//		// Given
//		let expectedDates = MovieResponseDates(maximum: "2024-12-31", minimum: "2024-01-01")
//		let expectedMovies = [Movie(id: 1, title: "Movie 1", overview: "", backdropPath: nil, genreIds: [], originalLanguage: "", originalTitle: "", popularity: 0, posterPath: nil, releaseDate: "", video: false, voteAverage: 0, voteCount: 0)]
//		let expectedResponse = MovieResponse(dates: expectedDates, page: 1, results: expectedMovies)
//		movieService.moviesResult = .success(expectedResponse)
//		
//		let expectation = XCTestExpectation(description: "Fetch movies success")
//		
//		// When
//		movieService.fetchMovies(.nowPlaying)
//			.sink(receiveCompletion: { completion in
//				if case let .failure(error) = completion {
//					XCTFail("Fetching movies failed with error: \(error.localizedDescription)")
//				}
//			}, receiveValue: { response in
//				// Then
//				XCTAssertTrue([response.dates.maximum == expectedDates.maximum,
//											 response.dates.minimum == expectedDates.minimum,
//											 response.page == expectedResponse.page,
//											 response.results.allSatisfy { movie in
//					expectedMovies.contains { $0.id == movie.id }
//				}].allSatisfy { $0 })
//				expectation.fulfill()
//			})
//			.store(in: &cancellables)
//		
//		// Wait for the expectation to be fulfilled
//		wait(for: [expectation], timeout: 1.0)
//	}
	
	
	
	
	
	func testFetchMovies_Failure() {
		// Given
		let expectedError = NSError(domain: "TestDomain", code: 404, userInfo: nil)
		movieService.moviesResult = .failure(expectedError)
		
		let expectation = XCTestExpectation(description: "Fetch movies failure")
		
		// When
		movieService.fetchMovies(.nowPlaying)
			.sink(receiveCompletion: { completion in
				// Then
				if case let .failure(error) = completion {
					XCTAssertEqual((error as NSError).code, expectedError.code)
					expectation.fulfill()
				}
			}, receiveValue: { _ in
				XCTFail("Expected failure, but received a successful response")
			})
			.store(in: &cancellables)
		
		// Wait for the expectation to be fulfilled
		wait(for: [expectation], timeout: 1.0)
	}
}
