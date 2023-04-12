//
//  API.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation
import Moya

enum API {
    case featchMatchesList(competitionId: String, token: String? = SecretsUtility.token.value)
}

extension API: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Constants.baseURL) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case let .featchMatchesList(competitionId, _):
            return "competitions/\(competitionId)/matches"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .featchMatchesList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headersDict = [String: String]()
        switch self {
        case let .featchMatchesList(_, token):
            if let token = token {
                Constants.authToken = token
                headersDict["X-Auth-Token"] = token
            }
            headersDict["Connection"] = "keep-alive"
        }
        return headersDict
    }
}
