//
//  KeychainAPIKeyProvider.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import Combine
import Foundation

class KeychainAPIKeyProvider: APIKeyProvider {
		
	func getAPIKey() -> AnyPublisher<String?, Error> {
		return KeychainService.shared.loadAPIKey()
			.flatMap { apiKey -> AnyPublisher<String?, Error> in
				if let apiKey = apiKey {
					return Just(apiKey)
						.setFailureType(to: Error.self)
						.eraseToAnyPublisher()
				} else {
					let error = NetworkError.invalidAPIKey("No API Key Found")
					return Fail<String?, Error>(error: error).eraseToAnyPublisher()
				}
			}
			.eraseToAnyPublisher()
	}
	// Below code is currently unused for the purposes of this test, it will be employed in the future for retrieving API keys from the server.
//	private func fetchAPIKeyFromServer() -> AnyPublisher<String?, Error> {
//		return networkService.getRequest(from: apiKeyURL, apiKeyProvider: KeychainAPIKeyProvider())
//			.tryMap { data -> String in
//				guard let apiKey = String(data: data, encoding: .utf8) else {
//					throw NSError(domain: "InvalidAPIKeyData", code: 0, userInfo: nil)
//				}
//				KeychainService.save(self.apiKeyKey, data: apiKey.data(using: .utf8)!)
//				return apiKey
//			}
//			.mapError { error -> Error in
//				return error
//			}
//			.eraseToAnyPublisher()
//	}
}
