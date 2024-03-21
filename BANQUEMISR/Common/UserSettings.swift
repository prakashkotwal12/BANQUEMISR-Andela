//
//  UserSettings.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 20/03/2024.
//

import Foundation
//The purpose of this class is to centralize the usage of localized settings. If, in the future, there is a plan to change the locale from App Settings, this class serves the purpose of handling such changes in a unified manner.
class UserSettings {
	static let shared = UserSettings()
	func getLanguage() -> String{
		return "en-US"
	}
}
