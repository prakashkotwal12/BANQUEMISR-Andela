//
//  PopularViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 20/03/2024.
//
class PopularViewModel: MovieViewModel {
	func fetchPopularMovies() {
		fetchNextMovie(for: .popular)
	}
}
