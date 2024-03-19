//
//  MovieRepository.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
import Combine

class MovieRepository {
	static let shared = MovieRepository()
	private let networkService: MovieServiceProtocol
	private let dataManager: MovieDataManager
	
	private init(networkService: MovieServiceProtocol = MovieNetworkService.shared,
							 dataManager: MovieDataManager = MovieDataManager.shared) {
		self.networkService = networkService
		self.dataManager = dataManager
	}
	
	func fetchMovies(_ type: MovieType) -> AnyPublisher<[Movie], Error> {
		return networkService.fetchMovies(type)
			.flatMap { [weak self] response -> AnyPublisher<[Movie], Error> in
				guard let self = self else {
					return Fail(error: MovieError.localError(NSError(domain: "", code: 0, userInfo: nil))).eraseToAnyPublisher()
				}
				return self.dataManager.saveMovies(response.results)
					.flatMap { _ in
						return Just(response.results)
							.setFailureType(to: Error.self)
							.eraseToAnyPublisher()
					}
					.catch { error -> AnyPublisher<[Movie], Error> in
						return Fail(error: MovieError.localError(error)).eraseToAnyPublisher()
					}
					.eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
	}
}
