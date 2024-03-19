//
//  MovieServiceProtocol.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Combine
// MARK: - Movie Service Protocol
protocol MovieServiceProtocol {
	func fetchMovies(_ type: MovieType) -> AnyPublisher<MovieResponse, Error>
}
