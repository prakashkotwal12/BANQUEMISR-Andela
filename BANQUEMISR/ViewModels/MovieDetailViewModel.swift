//
//  MovieDetailViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import Foundation
import Combine

class MovieDetailViewModel {
	private let movieID: Int
	private let movieRepository: MovieRepository
	
	@Published var movieDetail: MovieDetail?
	@Published var error: Error?
	
	private var cancellables: Set<AnyCancellable> = []
	
	init(movieID: Int, movieRepository: MovieRepository = MovieRepository.shared) {
		self.movieID = movieID
		self.movieRepository = movieRepository
	}
	
	func fetchMovieDetail() {
		movieRepository.fetchMovieDetail(movieID: movieID)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { [weak self] completion in
				switch completion {
					case .failure(let error):
						self?.error = error
					case .finished:
						break
				}
			}, receiveValue: { [weak self] movieDetail in
				self?.movieDetail = movieDetail
			})
			.store(in: &cancellables)
	}
}

//class MovieDetailViewModel {
//	private let movieID: Int
//	private let movieRepository: MovieRepository
//	private let dataManager: MovieDataManager
//	
//	@Published var movieDetail: MovieDetail?
//	@Published var error: Error?
//	
//	private var cancellables: Set<AnyCancellable> = []
//	
//	init(movieID: Int, movieRepository: MovieRepository = MovieRepository.shared, dataManager: MovieDataManager = MovieDataManager.shared) {
//		self.movieID = movieID
//		self.movieRepository = movieRepository
//		self.dataManager = dataManager
//	}
//	
//	func fetchMovieDetail() {
//		movieRepository.fetchMovieDetail(movieID: movieID)
//			.receive(on: DispatchQueue.main)
//			.flatMap { [weak self] movieDetail -> AnyPublisher<Void, Error> in
//				guard let self = self else {
//					return Fail(error: MovieError.localError(NSError(domain: "", code: 0, userInfo: nil))).eraseToAnyPublisher()
//				}
//				return self.saveMovieDetailToDatabase(movieDetail)
//			}
//			.flatMap { [weak self] _ in
//				self?.fetchMovieDetailFromDatabase() ?? Empty().eraseToAnyPublisher()
//			}
//			.sink(receiveCompletion: { [weak self] completion in
//				switch completion {
//					case .failure(let error):
//						self?.error = error
//					case .finished:
//						break
//				}
//			}, receiveValue: { [weak self] movieDetail in
//				self?.movieDetail = movieDetail
//			})
//			.store(in: &cancellables)
//	}
//	
//	private func saveMovieDetailToDatabase(_ movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
//		return dataManager.saveMovieDetail(movieDetail)
//	}
//	
//	private func fetchMovieDetailFromDatabase() -> AnyPublisher<MovieDetail?, Error> {
//		return dataManager.fetchMovieDetail(for: movieID)
//	}
//}
