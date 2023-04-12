//
//  Constants.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation
import KeychainAccess

struct Constants {
    static let baseURL = "https://api.football-data.org/v2/"
    
    @SecureSettingsOptionalItem(key: "authToken")
    static var authToken: String?
}


