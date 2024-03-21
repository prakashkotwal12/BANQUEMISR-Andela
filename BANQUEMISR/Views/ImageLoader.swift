//
//  Image.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import UIKit


class ImageLoader {
	static let shared = ImageLoader()
	
	private let imageCache = NSCache<NSURL, UIImage>()
	private let session = URLSession.shared
	
	private init() {}
	
	func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
		let nsUrl = url as NSURL
		// Check if the image is cached
		if let cachedImage = imageCache.object(forKey: nsUrl) {
			completion(cachedImage)
			return
		}
		
		var request = URLRequest(url: url)
		request.cachePolicy = .returnCacheDataElseLoad // Use cached data if available
		
		session.dataTask(with: request) { data, response, error in
			guard let data = data, let image = UIImage(data: data), error == nil else {
				completion(nil)
				return
			}
			
			// Cache the downloaded image
			self.imageCache.setObject(image, forKey: nsUrl)
			completion(image)
		}.resume()
	}
}

