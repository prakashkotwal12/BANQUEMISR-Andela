//
//  MovieRepository.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
import Combine

//class MovieRepository {
//	static let shared = MovieRepository()
//	private let networkService: MovieServiceProtocol
//	private let dataManager: MovieDataManager
//	
//	internal init(networkService: MovieServiceProtocol = MovieNetworkService.shared,
//								dataManager: MovieDataManager = MovieDataManager.shared) {
//		self.networkService = networkService
//		self.dataManager = dataManager
//	}
//	
//	func fetchMovies(_ type: MovieType, page : Int) -> AnyPublisher<[Movie], Error> {
//		return networkService.fetchMovies(type, page: page)
//			.flatMap { [weak self] response -> AnyPublisher<[Movie], Error> in
//				guard let self = self else {
//					return Fail(error: MovieError.localError(NSError(domain: "", code: 0, userInfo: nil))).eraseToAnyPublisher()
//				}
//				return self.dataManager.saveMovies(response.results)
//					.flatMap { _ in
//						return Just(response.results)
//							.setFailureType(to: Error.self)
//							.eraseToAnyPublisher()
//					}
//					.catch { error -> AnyPublisher<[Movie], Error> in
//						return Fail(error: MovieError.localError(error)).eraseToAnyPublisher()
//					}
//					.eraseToAnyPublisher()
//			}
//			.eraseToAnyPublisher()
//	}
//	
//	func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error> {
//		return networkService.fetchMovieDetail(movieID: movieID)
//	}
//}
class MovieRepository {
	static let shared = MovieRepository()
	private let networkService: NetworkService
	private let language = UserSettings.shared.getLanguage()
	
	internal init(networkService: NetworkService = NetworkService.shared) {
		self.networkService = networkService
	}
	
	func fetchMovies(_ type: MovieType, page: Int) -> AnyPublisher<MovieResponse, Error> {
		let addedParams = "?language=\(language)&page=\(page)"
		let endpoint: String
		switch type {
			case .nowPlaying:
				endpoint = "/movie/now_playing\(addedParams)"
			case .upcoming:
				endpoint = "/movie/upcoming\(addedParams)"
			case .popular:
				endpoint = "/movie/popular\(addedParams)"
		}
		return networkService.getRequest(from: endpoint)
	}
	func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error> {
		return networkService.getRequest(from: "/movie/\(movieID)")
	}
}

