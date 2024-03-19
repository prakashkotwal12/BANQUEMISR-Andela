//
//  ErrorModel.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import Foundation
struct ErrorResponse: Codable {
	let statusCode: Int
	let statusMessage: String
	let success: Bool
	enum CodingKeys: String, CodingKey {
		case success
		case statusCode = "status_code"
		case statusMessage = "status_message"
	}
}
