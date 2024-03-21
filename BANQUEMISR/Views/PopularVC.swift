//
//  PopularVC.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import UIKit
import Combine

class PopularVC: UIViewController {
	var movieItems: [Movie] = []
	private var viewModel: PopularViewModel!
	private var cancellables: Set<AnyCancellable> = []
	private var isLoading = false // Track if data is being loaded
	@IBOutlet weak var movieList: UITableView!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Registering a custom UICollectionViewCell subclass
		movieList.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
		
		// Do any additional setup after loading the view.
		setupViewModel()
		viewModel.fetchPopularMovies()
	}
	// MARK: - View Model Setup
	private func setupViewModel() {
		viewModel = PopularViewModel()
		
		// Subscribe to changes in nowPlayingMovies
		viewModel.$movies
			.receive(on: DispatchQueue.main) // Ensure updates are performed on the main thread
			.sink { [weak self] movies in
				// Reload table view data when nowPlayingMovies is updated
				//				print("fetched movies data: \(dump(movies))")
				//				if movies.count > 0, let firstMovie = movies.first{
				//					print("first movie: \(firstMovie)")
				//					self?.fetchDetail(movieId: firstMovie.id)
				//				}
				if movies.count > 0{
					
					
					self?.movieItems = movies
					self?.movieList.reloadData()
				}
				
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
	
	private func fetchDetail(movieId : Int){
		let movieDetail = MovieDetailVC()
		movieDetail.movieId = movieId
		self.navigationController?.pushViewController(movieDetail, animated: true)
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
	
//	
//	private func handleNewMovies(_ movies: [Movie]) {
//			isLoading = false
//			movieItems.append(contentsOf: movies)
//			movieList.reloadData()
//	}

	private func loadMoreMovies() {
		guard !isLoading else { return } // Prevent multiple simultaneous requests
		isLoading = true
//		currentPage += 1 // Increment page number
		viewModel.fetchPopularMovies()
		
	}
	/*
	 // MARK: - Navigation
	 
	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	 // Get the new view controller using segue.destination.
	 // Pass the selected object to the new view controller.
	 }
	 */
}

extension PopularVC : UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movieItems.count > 0 ? movieItems.count : 0
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : MovieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
		cell.configure(with: movieItems[indexPath.row])
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let movieDetail = MovieDetailVC()
		movieDetail.movieId = movieItems[indexPath.row].id
		self.navigationController?.pushViewController(movieDetail, animated: true)
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
		if indexPath.row == lastRowIndex {
			loadMoreMovies() // Load more movies when reaching the last row
		}
	}
	
	// Add the loader view as table view footer
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let activityIndicator = UIActivityIndicatorView(style: .medium)
		activityIndicator.startAnimating()
		return activityIndicator
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return isLoading ? 40 : 0 // Show loader footer only when loading
	}
}
