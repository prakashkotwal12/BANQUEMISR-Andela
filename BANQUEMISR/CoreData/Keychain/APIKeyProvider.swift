//
//  APIKeyProvider.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//
import Combine

protocol APIKeyProvider {
	func getAPIKey() -> AnyPublisher<String?, Error>
}
