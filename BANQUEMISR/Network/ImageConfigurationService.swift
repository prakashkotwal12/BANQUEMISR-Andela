//
//  ImageConfigurationService.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
import Combine
//
//class ImageConfigurationService {
//	static let shared = ImageConfigurationService()
//	
//	private var baseURL: String?
//	private var backdropSize: String?
//	private let networkService = NetworkService.shared
//	private var configurationsFetched = false
//	private let path = "/configuration"
//	
//	private init() {}
//	
//	// Fetches the image configurations from the server
//	private func fetchImageConfigurations() -> AnyPublisher<ImageConfigurationResponse, Error> {
//		return networkService.getRequest(from: path, apiKeyProvider: KeychainAPIKeyProvider())
//			.map { [weak self] (configuration: ImageConfigurationResponse) -> Void in
//				self?.baseURL = configuration.images.baseURL
//				self?.backdropSize = configuration.images.backdropSizes.last // Assuming you want the largest size
//				self?.configurationsFetched = true
//				return
//			}
//			.eraseToAnyPublisher()
//	}
//	
//	// Asynchronously gets the image URL
//	func getImageURL() -> AnyPublisher<String?, Error> {
////		if configurationsFetched {
////			return Just(self.constructURL(path: path))
////				.setFailureType(to: Error.self)
////				.eraseToAnyPublisher()
////		} else {
//			return fetchImageConfigurations()
//				.map { [weak self] _ in
//					return self?.constructURL(path: self?.path ?? "")
//				}
//				.eraseToAnyPublisher()
////		}
//	}
//	
//	// Constructs the image URL using the baseURL and backdropSize
//	private func constructURL(path: String) -> String? {
//		guard let baseURL = self.baseURL, let backdropSize = self.backdropSize else {
//			return nil
//		}
//		return "\(baseURL)\(backdropSize)\(path)"
//	}
//	
//}
class ImageConfigurationService {
	static let shared = ImageConfigurationService()
	
	private var baseURL: String?
	private var backdropSize: String = "original"
	private let networkService = NetworkService.shared
	private var configurationsFetched = false
	private let path = "/configuration"
	
	private init() {}
	
	// Fetches the image configurations from the server
//	private func fetchImageConfigurations() -> AnyPublisher<ImageConfigurationResponse, Error> {
//			let headers = [
//					"accept": "application/json",
//					"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZWIwYTRjMzczNDdjMzk1ZDNlYmY3YmI3MTUxZDBkZSIsInN1YiI6IjY1ZjdkODNjOTAzYzUyMDE2NTI4ODgwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7hm583x3XfD4UEjQHuyW0Et54Hu6-nZo8n1UMq4xaP8"
//			]
//
//			let url = URL(string: "https://api.themoviedb.org/3/configuration")!
//			var request = URLRequest(url: url)
//			request.httpMethod = "GET"
//			request.allHTTPHeaderFields = headers
//			request.timeoutInterval = 30
//
//			print("Fetching image configurations...")
//
//			return URLSession.shared.dataTaskPublisher(for: request)
//					.tryMap { data, response -> ImageConfigurationResponse in
//							guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//									print("Failed to fetch image configurations. Bad server response.")
//									throw URLError(.badServerResponse)
//							}
//
//							let decoder = JSONDecoder()
//							let configuration = try decoder.decode(ImageConfigurationResponse.self, from: data)
//							print("Image configurations fetched successfully.")
//							return configuration
//					}
//					.mapError { error -> Error in
//							// Map URLError to a more meaningful error if needed
//							print("Error fetching image configurations: \(error.localizedDescription)")
//							return error
//					}
//					.eraseToAnyPublisher()
//
//	}

	
	// Asynchronously gets the image URL
//	func getImageURL() -> AnyPublisher<String?, Error> {
//		return fetchImageConfigurations()
//			.map { [weak self] _ in
//				return self?.constructURL(path: self?.path ?? "")
//			}
//			.eraseToAnyPublisher()
//	}
//	func getImageURL(completion: @escaping (Result<String?, Error>) -> Void) {
//			guard let baseURL = self.baseURL else {//, let backdropSize = self.backdropSize
//					completion(.failure(NSError(domain: "ConfigurationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Base URL or backdrop size is missing"])))
//					return
//			}
//			
//			let urlString = constructURL(baseURL: baseURL, backdropSize: backdropSize, path: path)
//			print("Constructed URL: \(urlString)")
//			completion(.success(urlString))
//	}

	func getImageURL(completion: @escaping (Result<String?, Error>) -> Void) {
			fetchImageConfigurations { result in
					switch result {
					case .success(let (baseURL, backdropSizes)):
							guard let backdropSize = backdropSizes.last else {
									completion(.failure(NSError(domain: "ConfigurationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Backdrop size is missing"])))
									return
							}
							
							self.baseURL = baseURL
							
							let urlString = self.constructURL(baseURL: baseURL, backdropSize: backdropSize)
							print("Constructed URL: \(urlString)")
							completion(.success(urlString))
							
					case .failure(let error):
							print("Error fetching image configurations: \(error.localizedDescription)")
							completion(.failure(error))
					}
			}
	}

	private func constructURL(baseURL: String, backdropSize: String) -> String {
			return "\(baseURL)\(backdropSize)"
	}

	private func fetchImageConfigurations(completion: @escaping (Result<(String, [String]), Error>) -> Void) {
			let headers = [
					"accept": "application/json",
					"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZWIwYTRjMzczNDdjMzk1ZDNlYmY3YmI3MTUxZDBkZSIsInN1YiI6IjY1ZjdkODNjOTAzYzUyMDE2NTI4ODgwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7hm583x3XfD4UEjQHuyW0Et54Hu6-nZo8n1UMq4xaP8"
			]

			let url = URL(string: "https://api.themoviedb.org/3/configuration")!
			var request = URLRequest(url: url)
			request.httpMethod = "GET"
			request.allHTTPHeaderFields = headers
			request.timeoutInterval = 30

			print("Fetching image configurations...")

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
					if let error = error {
							completion(.failure(error))
							return
					}

					guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
							let error = URLError(.badServerResponse)
							completion(.failure(error))
							return
					}

					guard let data = data else {
							let error = URLError(.badServerResponse)
							completion(.failure(error))
							return
					}

					do {
							guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
										let images = jsonObject["images"] as? [String: Any],
										let baseURL = images["base_url"] as? String,
										let backdropSizes = images["backdrop_sizes"] as? [String] else {
									let error = NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
									completion(.failure(error))
									return
							}
							
							completion(.success((baseURL, backdropSizes)))
					} catch {
							completion(.failure(error))
					}
			}

			task.resume()
	}

	
}

//
//// Define models for Image Configuration Response
//struct ImageConfigurationResponse: Codable {
//		let images: ImageConfiguration
//		let changeKeys: [String]
//}
//
//struct ImageConfiguration: Codable {
//		let baseURL: String
//		let backdropSizes: [String]
//		// Define other image sizes as needed
//}
//
//struct ImageConfigurationResponse: Codable {
//	let images: Images
//	let changeKeys: [String]
//	
//	struct Images: Codable {
//		let baseURL: String
//		let secureBaseURL: String
//		let backdropSizes: [String]
//		let logoSizes: [String]
//		let posterSizes: [String]
//		let profileSizes: [String]
//		let stillSizes: [String]
//		
//		enum CodingKeys: String, CodingKey {
//			case baseURL = "base_url"
//			case secureBaseURL = "secure_base_url"
//			case backdropSizes = "backdrop_sizes"
//			case logoSizes = "logo_sizes"
//			case posterSizes = "poster_sizes"
//			case profileSizes = "profile_sizes"
//			case stillSizes = "still_sizes"
//		}
//	}
//}
/*- some : "{\"images\":{\"base_url\":\"http://image.tmdb.org/t/p/\",\"secure_base_url\":\"https://image.tmdb.org/t/p/\",\"backdrop_sizes\":[\"w300\",\"w780\",\"w1280\",\"original\"],\"logo_sizes\":[\"w45\",\"w92\",\"w154\",\"w185\",\"w300\",\"w500\",\"original\"],\"poster_sizes\":[\"w92\",\"w154\",\"w185\",\"w342\",\"w500\",\"w780\",\"original\"],\"profile_sizes\":[\"w45\",\"w185\",\"h632\",\"original\"],\"still_sizes\":[\"w92\",\"w185\",\"w300\",\"original\"]},\"change_keys\":[\"adult\",\"air_date\",\"also_known_as\",\"alternative_titles\",\"biography\",\"birthday\",\"budget\",\"cast\",\"certifications\",\"character_names\",\"created_by\",\"crew\",\"deathday\",\"episode\",\"episode_number\",\"episode_run_time\",\"freebase_id\",\"freebase_mid\",\"general\",\"genres\",\"guest_stars\",\"homepage\",\"images\",\"imdb_id\",\"languages\",\"name\",\"network\",\"origin_country\",\"original_name\",\"original_title\",\"overview\",\"parts\",\"place_of_birth\",\"plot_keywords\",\"production_code\",\"production_companies\",\"production_countries\",\"releases\",\"revenue\",\"runtime\",\"season\",\"season_number\",\"season_regular\",\"spoken_languages\",\"status\",\"tagline\",\"title\",\"translations\",\"tvdb_id\",\"tvrage_id\",\"type\",\"video\",\"videos\"]}"*/
//struct ImageConfigurationResponse: Codable {
//		let images: Images
//		let changeKeys: [String]
//		
//		struct Images: Codable {
//				let baseURL: String
//				let secureBaseURL: String
//				let backdropSizes: [String]
//				let logoSizes: [String]
//				let posterSizes: [String]
//				let profileSizes: [String]
//				let stillSizes: [String]
//				
//				enum CodingKeys: String, CodingKey {
//						case baseURL = "base_url"
//						case secureBaseURL = "secure_base_url"
//						case backdropSizes = "backdrop_sizes"
//						case logoSizes = "logo_sizes"
//						case posterSizes = "poster_sizes"
//						case profileSizes = "profile_sizes"
//						case stillSizes = "still_sizes"
//				}
//				
//				// Print coding keys for debugging
//				public var debugDescription: String {
//						return """
//						Coding Keys:
//						baseURL
//						secureBaseURL
//						backdropSizes
//						logoSizes
//						posterSizes
//						profileSizes
//						stillSizes
//						"""
//				}
//		}
//		
//		// Print coding keys for debugging
//		public var debugDescription: String {
//				var description = "Image Configuration Response Coding Keys:\n"
//				for key in self.allKeys {
//						description += "\(key.stringValue)\n"
//				}
//				return description
//		}
//}
