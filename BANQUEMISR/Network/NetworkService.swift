//
//  NetworkService.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
import Combine

class NetworkService {
	static let shared = NetworkService()
	private var networkMonitor = NetworkMonitor.shared
	private let baseURL = "https://api.themoviedb.org/3"
	private var cancellables: Set<AnyCancellable> = [] // Declare cancellables

	public var connectionState : ConnectionState = .offline
	
	private func observeNetworkChanges() {
		networkMonitor.objectWillChange
			.sink { [weak self] _ in
				// Respond to network changes here
				self?.connectionState = self?.networkMonitor.connectionState ?? .offline
				print("Network state changed to: \(self?.networkMonitor.connectionState ?? .offline)")
			}
			.store(in: &cancellables) // Make sure to store the subscription to prevent it from being deallocated
	}
	
	func getRequest<T: Decodable>(from path: String, apiKeyProvider: APIKeyProvider) -> AnyPublisher<T, Error> {
		let apiKeyPublisher = apiKeyProvider.getAPIKey()
		print("check for api key: \(apiKeyPublisher.description)")
		return apiKeyPublisher
			.tryMap { apiKey -> URLRequest in
				guard let apiKey = apiKey else {
					throw NetworkError.invalidAPIKey(apiKey ?? "No Key")
				}
				guard let url = URL(string: "\(self.baseURL)\(path)") else{
					throw NetworkError.invalidURL
				}
				print("final url: \(url)")
				var request = URLRequest(url: url)
				request.httpMethod = "GET"
				request.allHTTPHeaderFields = [
					"accept": "application/json",
					"Authorization": "Bearer \(apiKey)"
				]
				request.cachePolicy = .useProtocolCachePolicy
				request.timeoutInterval = 120.0
				return request
			}
			.flatMap { request -> AnyPublisher<(data: Data, response: URLResponse), Error> in
				return URLSession.shared.dataTaskPublisher(for: request)
					.mapError { error in
						self.handleNetworkError(error)
					}
					.eraseToAnyPublisher()
			}
			.tryMap { data, response -> T in
				guard let httpResponse = response as? HTTPURLResponse else {
					throw NetworkError.invalidResponse
				}
				guard (200...299).contains(httpResponse.statusCode) else {
					if let error = self.handleHTTPStatusCode(httpResponse.statusCode, data: data) {
						throw error
					} else {
						throw NetworkError.unknownError
					}
				}
				return try JSONDecoder().decode(T.self, from: data)
			}
			.mapError { error in
				self.handleMappingError(error)
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
	
	private func handleNetworkError(_ error: Error) -> Error {
		if self.networkMonitor.connectionState == .offline {
			return error
		} else {
			return NetworkError.noInternet
		}
	}
	
	private func handleHTTPStatusCode(_ httpResponseCode: Int, data: Data) -> Error? {
		switch httpResponseCode {
			case 401:
				let decoder = JSONDecoder()
				if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
					return MovieError.networkError(NetworkError.invalidAPIKey(errorResponse.statusMessage))
				} else {
					return NetworkError.invalidResponse
				}
			case 404:
				return NetworkError.invalidURL
			default:
				return NetworkError.invalidStatusCode(httpResponseCode)
		}
	}
	
	private func handleMappingError(_ error: Error) -> Error {
		if let decodingError = error as? DecodingError {
			return NetworkError.decodingError(decodingError)
		} else if let networkError = error as? NetworkError {
			return networkError
		} else if let movieError = error as? MovieError {
			return movieError
		} else {
			return error
		}
	}
}

