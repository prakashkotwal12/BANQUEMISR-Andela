//
//  MovieDetailViewModelTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//

import XCTest
import Combine
@testable import BANQUEMISR

class MovieDetailViewModelTests: XCTestCase {
	var sut: MovieDetailViewModel!
	var cancellables: Set<AnyCancellable>!
	
	override func setUp() {
		super.setUp()
		cancellables = []
		// Initialize with a mock repository
		sut = MovieDetailViewModel(movieID: 123, movieRepository: MockMovieRepository())
	}
	
	override func tearDown() {
		cancellables = nil
		sut = nil
		super.tearDown()
	}
	
	func testFetchMovieDetail_Success() {
		// Given
		let expectedMovieDetail = MovieDetail(
			adult: false,
			backdropPath: "/exampleBackdropPath.jpg",
			belongsToCollection: BelongsToCollection(id: 123, name: "Example Collection", posterPath: "/examplePosterPath.jpg", backdropPath: "/exampleBackdropPath.jpg"),
			budget: 1000000,
			genres: [
				Genre(id: 1, name: "Action"),
				Genre(id: 2, name: "Adventure")
			],
			homepage: "https://example.com",
			id: 123456,
			imdbID: "tt123456",
			originalLanguage: "English",
			originalTitle: "Original Title",
			overview: "Movie overview description.",
			popularity: 7.8,
			posterPath: "/examplePosterPath.jpg",
			productionCompanies: [
				ProductionCompany(id: 1, logoPath: "/exampleLogoPath.jpg", name: "Example Production Company", originCountry: "US")
			],
			productionCountries: [
				ProductionCountry(iso_3166_1: "US", name: "United States")
			],
			releaseDate: "2023-01-01",
			revenue: 10000000,
			runtime: 120,
			spokenLanguages: [
				SpokenLanguage(englishName: "English", iso_639_1: "en", name: "English")
			],
			status: "Released",
			tagline: "Example Tagline",
			title: "Example Movie Title",
			video: true,
			voteAverage: 8.0,
			voteCount: 1000
		)
		
		let mockRepository = MockMovieDetailRepository(mDetail: expectedMovieDetail)
		sut = MovieDetailViewModel(movieID: 123, movieRepository: mockRepository)
		
		let expectation = self.expectation(description: "Movie detail fetched successfully")
		var receivedMovieDetail: MovieDetail?
		
		// When
		sut.$movieDetail
			.dropFirst() // Skip initial nil value
			.sink { movieDetail in
				receivedMovieDetail = movieDetail
				expectation.fulfill()
			}
			.store(in: &cancellables)
		
		sut.fetchMovieDetail()
		
		// Then
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(receivedMovieDetail)
		XCTAssertEqual(receivedMovieDetail?.id, expectedMovieDetail.id)
		XCTAssertNil(sut.error)
	}	
}
