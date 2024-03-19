//
//  MovieViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
import Combine

class MovieViewModel: NSObject {
	private let repository: MovieRepository
	private var cancellables: Set<AnyCancellable> = []
	
	@Published var nowPlayingMovies: [Movie] = []
	@Published var error: Error?
	
	init(repository: MovieRepository = MovieRepository.shared) {
		self.repository = repository
		super.init()
		fetchNowPlayingMovies()
	}
	
	func fetchNowPlayingMovies() {
		repository.fetchMovies(.nowPlaying)
			.sink(receiveCompletion: { [weak self] completion in
				if case let .failure(error) = completion {
					self?.error = error
				}
			}, receiveValue: { [weak self] movies in
				self?.error = nil // Reset error on successful fetch
				self?.nowPlayingMovies = movies
			})
			.store(in: &cancellables)
	}
}

