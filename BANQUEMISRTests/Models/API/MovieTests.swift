//
//  MovieTests.swift
//  BANQUEMISRTests
//
//  Created by Prakash Kotwal on 19/03/2024.
//


import XCTest
@testable import BANQUEMISR

//class MovieTests: XCTestCase {
//	
//	func testEncodeMovie() throws {
//		// Given
//		let movie = Movie(
//			id: 1011985,
//			title: "Kung Fu Panda 4",
//			overview: "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
//			backdropPath: "/gJL5kp5FMopB2sN4WZYnNT5uO0u.jpg",
//			genreIds: [28, 12, 16, 35, 10751],
//			originalLanguage: "en",
//			originalTitle: "Kung Fu Panda 4",
//			popularity: 5294.537,
//			posterPath: "/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg",
//			releaseDate: "2024-03-02",
//			video: false,
//			voteAverage: 6.895,
//			voteCount: 166
//		)
//		let expectedJSON = """
//	{
//		"id": 1011985,
//		"title": "KungFuPanda4",
//		"overview": "PoisgearinguptobecomethespiritualleaderofhisValleyofPeace,butalsoneedssomeonetotakehisplaceasDragonWarrior.Assuch,hewilltrainanewkungfupractitionerforthespotandwillencounteravillaincalledtheChameleonwhoconjuresvillainsfromthepast.",
//		"backdrop_path": "/gJL5kp5FMopB2sN4WZYnNT5uO0u.jpg",
//		"genre_ids": [28, 12, 16, 35, 10751],
//		"original_language": "en",
//		"original_title": "KungFuPanda4",
//		"popularity": 5294.537,
//		"poster_path": "/wkfG7DaExmcVsGLR4kLouMwxeT5.jpg",
//		"release_date": "2024-03-02",
//		"video": false,
//		"vote_average": 6.895,
//		"vote_count": 166
//	}
//	"""
//		
//		
//		
//		
//		let encoder = JSONEncoder()
//		encoder.outputFormatting = .sortedKeys // Ensure consistent ordering for comparison
//		let encodedData = try encoder.encode(movie)
//		let encodedJSONString = String(data: encodedData, encoding: .utf8)!
//		
//		// Then
//		XCTAssertEqual(encodedJSONString, expectedJSON)
//	}
//	
//}
//
