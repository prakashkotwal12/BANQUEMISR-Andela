//
//  MovieViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import Foundation
import Combine

class MovieViewModel: NSObject {
	let repository: MovieRepository
	var cancellables: Set<AnyCancellable> = []
	private let dataManager: MovieDataManager
	
	@Published var movies: [Movie] = []
	@Published var error: Error?
	var currentPage = 0
	var totalPages = 0
	var totalResults = 0
	var isDataFetched : Bool = false
	
	init(repository: MovieRepository = MovieRepository.shared, dataManager: MovieDataManager = MovieDataManager.shared) {
		self.repository = repository
		self.dataManager = dataManager
		super.init()
	}
	
	func fetchNextMovie(for movieType: MovieType) {
		if isDataFetched && currentPage < totalPages {
			currentPage += 1
		} else {
			currentPage = 1
		}
		fetchMovies(for: movieType)
	}
	
	private func fetchMovies(for movieType: MovieType) {
		repository.fetchMovies(movieType, page: currentPage)
			.flatMap { [weak self] response -> AnyPublisher<[Movie], Error> in
				guard let self = self else {
					return Fail(error: MovieError.localError(NSError(domain: "", code: 0, userInfo: nil))).eraseToAnyPublisher()
				}
				self.isDataFetched = true
				self.totalPages = response.totalPages
				self.totalResults = response.totalResults
				return self.saveMoviesToDatabase(response.results)
			}
			.sink(receiveCompletion: { [weak self] completion in
				if case let .failure(error) = completion {
					self?.error = error
				}
			}, receiveValue: { [weak self] _ in
				self?.error = nil // Reset error on successful fetch
				// Movies are already appended to the array in saveMoviesToDatabase function
			})
			.store(in: &cancellables)
	}
	
	private func saveMoviesToDatabase(_ movies: [Movie]) -> AnyPublisher<[Movie], Error> {
		return fetchMoviesFromDatabase()
			.flatMap { savedMovies -> AnyPublisher<Void, Error> in
				// Filter out movies that are not already present in the database
				let newMovies = movies.filter { movie in
					!savedMovies.contains(where: { $0.id == movie.id }) // Assuming 'id' is a unique identifier for movies
				}
				guard !newMovies.isEmpty else {
					return Result.Publisher(()).eraseToAnyPublisher() // Return empty array if no new movies to save
				}
				
				// Call the appropriate method to save only the new movies to the local database
				return self.dataManager.saveMovies(newMovies)
			}
			.flatMap { _ in
				self.fetchMoviesFromDatabase() // Fetch saved movies after saving
			}
			.eraseToAnyPublisher()
	}
	private func fetchMoviesFromDatabase() -> AnyPublisher<[Movie], Error> {
		return dataManager.fetchNowPlayingMovies()
			.map { savedMovies -> [Movie] in
				// Append the newly added movies to the existing movies array
				self.movies = savedMovies//.append(contentsOf: savedMovies)
				return self.movies
			}
			.eraseToAnyPublisher()
	}	
}





