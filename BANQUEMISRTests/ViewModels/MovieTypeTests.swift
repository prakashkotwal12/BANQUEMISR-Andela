//
//  MovieTypeTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import XCTest
@testable import BANQUEMISR
class MovieTypeTests: XCTestCase {
	
	func testRawValues() {
		XCTAssertEqual(MovieType.nowPlaying.rawValue, "now_playing")
		XCTAssertEqual(MovieType.upcoming.rawValue, "upcoming")
		XCTAssertEqual(MovieType.popular.rawValue, "popular")
	}	
}

