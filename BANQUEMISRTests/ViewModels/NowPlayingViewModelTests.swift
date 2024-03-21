//
//  NowPlayingViewModelTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 21/03/2024.
//
import XCTest
import Combine
@testable import BANQUEMISR

//class NowPlayingViewModelTests: XCTestCase {
//	// MARK: - Test Cases
//	
//	func testFetchNowPlayingMovies() {
//		// Given
//		let viewModel = NowPlayingViewModel(repository: MockMovieRepository())
//		let expectation = XCTestExpectation(description: "Fetch now playing movies")
//		
//		// When
//		viewModel.fetchNowPlayingMovies()
//		
//		// Then
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//			// Assuming fetchNextMovie is called immediately and takes 1 second to complete
//			XCTAssertFalse(viewModel.movies.isEmpty)
//			XCTAssertNil(viewModel.error)
//			XCTAssertEqual(viewModel.currentPage, 1)
//			expectation.fulfill()
//		}
//		
//		wait(for: [expectation], timeout: 2)
//	}	
//}
//
