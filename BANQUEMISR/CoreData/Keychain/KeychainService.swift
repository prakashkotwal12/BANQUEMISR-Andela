//
//  KeychainService.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import Combine
import Foundation


//// Error enum for Keychain errors
enum KeychainError: Error {
	case saveFailure
	case loadFailure
}

class KeychainService {
	static let shared = KeychainService()
	
	private let apiKeyKey = "com.ANDELA.BANQUEMISR"
	private let hardcodedAPIKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlZWIwYTRjMzczNDdjMzk1ZDNlYmY3YmI3MTUxZDBkZSIsInN1YiI6IjY1ZjdkODNjOTAzYzUyMDE2NTI4ODgwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7hm583x3XfD4UEjQHuyW0Et54Hu6-nZo8n1UMq4xaP8"
	
	private var subscriptions = Set<AnyCancellable>()
	
	func loadAPIKey() -> AnyPublisher<String?, Error> {
		return Future<String?, Error> { promise in
			if let apiKey = self.loadAPIKeyFromKeychain() {
				promise(.success(apiKey))
			} else {
				self.saveHardcodedAPIKey()
				self.loadAPIKey() // Recursively call to fetch the saved API key
					.sink(receiveCompletion: { _ in }, receiveValue: { apiKey in
						promise(.success(apiKey))
					})
					.store(in: &self.subscriptions)
			}
		}
		.eraseToAnyPublisher()
	}
	
	private func saveHardcodedAPIKey() {
		guard let data = hardcodedAPIKey.data(using: .utf8) else {
			print("Failed to convert API key to data")
			return
		}
		
		do {
			try self.save(apiKeyKey, data: data)
		} catch {
			print("Failed to save API key to Keychain: \(error)")
		}
	}
	
	private func loadAPIKeyFromKeychain() -> String? {
		do {
			return try load(apiKeyKey)
		} catch {
			print("Failed to load API key from Keychain: \(error)")
			return nil
		}
	}
	
	internal func save(_ key: String, data: Data) throws {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecValueData as String: data
		]
		
		// Delete any existing item with the same key before saving the new one
		SecItemDelete(query as CFDictionary)
		
		let status = SecItemAdd(query as CFDictionary, nil)
		guard status == errSecSuccess else {
			throw KeychainError.saveFailure
		}
	}
	
	private func load(_ key: String) throws -> String? {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var item: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &item)
		
		switch status {
			case errSecSuccess:
				guard let data = item as? Data else { return nil }
				return String(data: data, encoding: .utf8)
			case errSecItemNotFound:
				return nil
			default:
				throw KeychainError.loadFailure
		}
	}
	
}
