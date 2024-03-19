//
//  MovieNetworkService.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Combine

class MovieNetworkService: MovieServiceProtocol {
	static let shared = MovieNetworkService()
	
	private let networkService = NetworkService.shared
	
	// Modify the fetchMovies method to accept MovieType enum
	func fetchMovies(_ type: MovieType) -> AnyPublisher<MovieResponse, Error> {
		let endpoint: String
		switch type {
			case .nowPlaying:
				endpoint = "/movie/now_playing"
			case .upcoming:
				endpoint = "/movie/upcoming"
			case .popular:
				endpoint = "/movie/popular"
		}
		return networkService.getRequest(from: endpoint, apiKeyProvider: KeychainAPIKeyProvider())
	}
	
	func fetchMovieDetail(movieID: Int) -> AnyPublisher<Movie, Error> {
		return networkService.getRequest(from: "/movie/\(movieID)", apiKeyProvider: KeychainAPIKeyProvider())
	}
}
