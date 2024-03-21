//
//  MovieListCell.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import UIKit

class MovieListCell: UITableViewCell {
	let imageConfig = ImageConfigurationService.shared
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var posterImageView: UIImageView!
	@IBOutlet weak var labelReleaseDate: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	func configure(with item: Movie) {
		if let posterPath = item.posterPath{
			fetchImage(path: posterPath) { result in
				switch result {
					case .success(let imageURL):
						print("Image URL: \(imageURL)")
						// Add code to use the imageURL here
					case .failure(let error):
						print("Error fetching image: \(error.localizedDescription)")
						// Handle the error here
				}
			}
			
		}
		
		labelTitle.text = item.title
		labelReleaseDate.text = "Released on : \(item.releaseDate)"
	}
	
	private func fetchImage(path: String, completion: @escaping (Result<String, Error>) -> Void) {
		ImageConfigurationService.shared.getImageURL { result in
			switch result {
				case .success(let imageURL):
					guard let baseURL = imageURL else {
						completion(.failure(NetworkError.invalidResponse))
						return
					}
					let completeURL = "\(baseURL)\(path)"
					print("complete url: \(completeURL)")
					self.updateImage(imageUrlString: completeURL)
					completion(.success(completeURL))
				case .failure(let error):
					completion(.failure(error))
			}
		}
		
	}
	
	
	private func updateImage(imageUrlString : String){
		if let imageUrl = URL(string: imageUrlString) {
			ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
				if let img = image{
					DispatchQueue.main.async {
						self?.posterImageView.image = img
					}
				}
			}
//			ImageCache.publicCache.load(url: imageUrl as NSURL) { [weak self] (image) in
//				if let img = image{
////					DispatchQueue.main.async {
//						self?.posterImageView.image = img
////					}
//				}
//			}
		}
	}	
}
