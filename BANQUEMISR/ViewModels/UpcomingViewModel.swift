//
//  UpcomingViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 20/03/2024.
//

class UpcomingViewModel: MovieViewModel {
	func fetchUpcomingMovies() {
		fetchNextMovie(for: .upcoming)
	}	
}
