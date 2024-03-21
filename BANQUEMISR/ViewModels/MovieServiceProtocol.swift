//
//  MovieServiceProtocol.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Combine
// MARK: - Movie Service Protocol
protocol MovieServiceProtocol {
	func fetchMovies(_ type: MovieType, page: Int) -> AnyPublisher<MovieResponse, Error>
	func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error>	
}

extension MovieServiceProtocol {
	func fetchMovies(_ type: MovieType, page: Int) -> AnyPublisher<MovieResponse, Error> {
		fatalError("Method not implemented")
	}
	
	func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error> {
		fatalError("Method not implemented")
	}
}
