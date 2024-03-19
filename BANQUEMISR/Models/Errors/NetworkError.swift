//
//  NetworkError.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

enum NetworkError: Error {
	case invalidURL
	case noData
	case invalidResponse
	case decodingError(Error)
	case invalidStatusCode(Int)
	case noInternet
	case invalidAPIKey(String)
	case unknownError
	
	func errorMessage() -> String {
		switch self {
			case .noInternet:
				return "No internet connection."
			case .invalidURL:
				return "Invalid URL."
			case .invalidResponse:
				return "Invalid server response."
			case .decodingError(let decodingError):
				return "Decoding error: \(decodingError.localizedDescription)"
			case .invalidStatusCode(let statusCode):
				return "Invalid status code: \(statusCode)"
			case .invalidAPIKey(let message):
				return "Invalid API key: \(message)"
			case .unknownError:
				return "Unknown error occurred."
			default:
				return "An error occurred."
		}
	}	
}

