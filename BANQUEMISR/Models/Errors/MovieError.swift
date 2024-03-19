//
//  MovieError.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
enum MovieError: Error {
	case networkError(Error)
	case localError(Error)
	case unknownError
	
	func errorMessage() -> String {
		switch self {
			case .networkError(let error):
				if let networkError = error as? NetworkError{
					return networkError.errorMessage()
				}
				if let networkError = error as? CoreDataError{
					return networkError.errorMessage()
				}
				return "Network error: \(error.localizedDescription)"
			case .localError(let error):
				if let coreDataError = error as? CoreDataError {
					return coreDataError.errorMessage()
				}
				return "Local error: \(error.localizedDescription)"
			case .unknownError:
				return "Unknown error occurred."
		}
	}	
}
