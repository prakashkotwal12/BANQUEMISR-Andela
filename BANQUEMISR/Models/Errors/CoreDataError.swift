//
//  CoreDataError.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

enum CoreDataError: Error {
	case saveError(Error)
	case fetchError(Error)
	case deleteError(Error)
	case unknownError
	
	func errorMessage() -> String {
		switch self {
			case .saveError(let error):
				return "Save error: \(error.localizedDescription)"
			case .fetchError(let error):
				return "Fetch error: \(error.localizedDescription)"
			case .deleteError(let error):
				return "Delete error: \(error.localizedDescription)"
			case .unknownError:
				return "Unknown error occurred."
		}
	}	
}
