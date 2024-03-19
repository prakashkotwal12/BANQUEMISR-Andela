//
//  ViewController.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import UIKit
import Combine

class ViewController: UIViewController {
	
	private var viewModel: MovieViewModel!
	private var cancellables: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("view loaded")
		setupViewModel()
		viewModel.fetchNowPlayingMovies()
	}
	// MARK: - View Model Setup
	private func setupViewModel() {
		viewModel = MovieViewModel()
		
		// Subscribe to changes in nowPlayingMovies
		viewModel.$nowPlayingMovies
			.receive(on: DispatchQueue.main) // Ensure updates are performed on the main thread
			.sink { [weak self] movies in
				// Reload table view data when nowPlayingMovies is updated
				print("fetched movies data: \(dump(movies))")
//				self?.movieListTV.reloadData()
			}
			.store(in: &cancellables)
		
		// Subscribe to error events
		viewModel.$error
			.receive(on: DispatchQueue.main)
			.sink { [weak self] error in
				guard let self = self else { return }
				self.handleError(error)
				
			}
			.store(in: &cancellables)
	}
	
	// Display alert for error
	private func handleError(_ error: Error?) {
		
		//		let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
		//		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		//		present(alert, animated: true, completion: nil)
		var errorMessage: String
		
		if let movieError = error as? MovieError {
			errorMessage = movieError.errorMessage()
		} else if let networkError = error as? NetworkError {
			errorMessage = networkError.errorMessage()
		}else if let coreDataError = error as? CoreDataError {
			errorMessage = coreDataError.errorMessage()
		}
		else {
			errorMessage = error?.localizedDescription ?? "Unknown error occurred."
		}
		print("errors testing count \(errorMessage)")
		//		self.displayErrorAlert(errorMessage)
	}
}


