//
//  MovieDataManagerTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//
@testable import BANQUEMISR
import XCTest
import Combine
import CoreData

class MovieDataManagerTests: XCTestCase {
	
	var movieDataManager: MovieDataManager!
	// Given
	private let movies =
	[
		Movie(id: 1, title: "Movie 1", overview: "Overview 1", backdropPath: nil, genreIds: [], originalLanguage: "", originalTitle: "", popularity: 0, posterPath: nil, releaseDate: "", video: false, voteAverage: 0, voteCount: 0),
		Movie(id: 2, title: "Movie 2", overview: "Overview 2", backdropPath: nil, genreIds: [], originalLanguage: "", originalTitle: "", popularity: 0, posterPath: nil, releaseDate: "", video: false, voteAverage: 0, voteCount: 0)
	]
	override func setUp() {
		super.setUp()
		movieDataManager = MovieDataManager.shared
	}
	
	override func tearDown() {
		movieDataManager = nil
		super.tearDown()
	}
	
	func testSaveMovies_Successful() {
		
		
		// When
		let publisher = movieDataManager.saveMovies(movies)
		
		// Then
		let expectation = XCTestExpectation(description: "Movies saved successfully")
		
		let cancellable = publisher
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						expectation.fulfill()
					case .failure(let error):
						XCTFail("Failed to save movies: \(error)")
				}
			}, receiveValue: { _ in })
		
		wait(for: [expectation], timeout: 5.0)
		cancellable.cancel()
	}
	
	
	func testSaveMovies_EmptyArray() {
		// Given
		let movies: [Movie] = []
		
		// When
		let publisher = movieDataManager.saveMovies(movies)
		
		// Then
		let expectation = XCTestExpectation(description: "Save movies with empty array")
		
		let cancellable = publisher
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						expectation.fulfill()
					case .failure(let error):
						XCTFail("Failed to save movies: \(error)")
				}
			}, receiveValue: { _ in })
		
		wait(for: [expectation], timeout: 5.0)
		cancellable.cancel()
	}	
}

