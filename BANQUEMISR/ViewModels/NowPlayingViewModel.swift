//
//  NowPlayingViewModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 20/03/2024.
//
class NowPlayingViewModel: MovieViewModel {
	func fetchNowPlayingMovies() {
		fetchNextMovie(for: .nowPlaying)
	}
}
