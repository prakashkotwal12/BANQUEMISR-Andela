//
//  MovieDetailVC.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import UIKit
import Combine

class MovieDetailVC: UIViewController {
	var movieId: Int?
	var viewModel: MovieDetailViewModel?
	private var cancellables: Set<AnyCancellable> = []
	var movieDetail: MovieDetail?
	@IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var labelMoviewtitle: UILabel!
    @IBOutlet weak var labelRuntime: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var tvOverView: UITextView!
    @IBOutlet weak var imagePoster: UIImageView!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewModel()
		fetchMovieDetail()
		
//		self.navigationController?.navigationBar.backgroundColor = UIColor.alumin
	}
	
	private func setupViewModel() {
		guard let movieId = movieId else {
			fatalError("Movie ID is not provided")
		}
		viewModel = MovieDetailViewModel(movieID: movieId)
		viewModel?.$movieDetail
			.sink { [weak self] movieDetail in
				self?.movieDetail = movieDetail
				self?.updateUI()
			}
			.store(in: &cancellables)
		viewModel?.$error
			.sink { [weak self] error in
				if let error = error {
					self?.handleError(error)
				}
			}
			.store(in: &cancellables)
	}
	
	
	private func fetchMovieDetail() {
		viewModel?.fetchMovieDetail()
	}
	
	private func updateUI() {
		if let movieDetail {
			// Update UI elements with movieDetail properties
            var totalGenres = ""
            for genre in movieDetail.genres{
                if totalGenres == ""{
                    totalGenres = genre.name
                }else{
                    totalGenres = "\(totalGenres), \(genre.name)"
                }
                
            }
            let duration: Int = Int(movieDetail.runtime)
            let durationInHourMin = secondsToHoursMinutes(duration)
//			movieTitle.text = movieDetail.title
            labelMoviewtitle.text = movieDetail.title
            labelRuntime.text = "Release Date: \(movieDetail.releaseDate) | Duration: \(durationInHourMin.0)h \(durationInHourMin.1)m"
            labelGenres.text = "Genre: \(totalGenres)"
            tvOverView.text = movieDetail.overview
			print("in detail totle \(movieDetail.title)")
            print("in detail totle \(movieDetail.overview)")
            print("in detail totle \(movieDetail.genres)")
            print("in detail totle \(movieDetail.runtime)")
//			fetchImage(self.backdropImage, path: movieDetail.backdropPath ?? "")
            fetchImage(self.posterImage, path: movieDetail.posterPath ?? "")
			// Example:
			// titleLabel.text = movieDetail.title
			// overviewLabel.text = movieDetail.overview
			// posterImageView.image = UIImage(named: movieDetail.posterPath)
			// etc.
		}
	}
	
    func secondsToHoursMinutes(_ minutes: Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }
	
	private func fetchImage(_ imageView : UIImageView, path: String) {
		ImageConfigurationService.shared.getImageURL { result in
			switch result {
				case .success(let imageURL):
					guard let baseURL = imageURL else {
						//						completion(.failure(NetworkError.invalidResponse))
						print("fail to load image: invalid response")
						return
					}
					let completeURL = "\(baseURL)\(path)"
					print("complete url: \(completeURL)")
					self.updateImage(imageView, imageUrlString: completeURL)
					//					completion(.success(completeURL))
				case .failure(let error):
					print("fail to load image: \(error.localizedDescription)")
					//					completion(.failure(error))
			}
		}
		
	}
	
	
	private func updateImage(_ imageView : UIImageView, imageUrlString : String){
		if let imageUrl = URL(string: imageUrlString) {
			ImageLoader.shared.loadImage(from: imageUrl) {  image in
				if let img = image{
					DispatchQueue.main.async {
						imageView.image = img
					}
				}
			}
		}
	}
	
	private func handleError(_ error: Error) {
		// Handle error
		print("Error: \(error)")
	}
	
	deinit {
		cancellables.removeAll()
	}
}
