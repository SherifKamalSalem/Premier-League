//
//  API.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Moya
import Foundation

enum API {
    case matchList(competitionId: String)
}

extension API: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.baseURL) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case let .matchList(competitionId):
            return "competitions/\(competitionId)/matches"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .matchList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
