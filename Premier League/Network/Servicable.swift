//
//  Servicable.swift
//  Premier League
//
//  Created by Sherif Kamal on 07/04/2023.
//

import Foundation
import Combine
import Moya

protocol Serviceable {
    func fetchFixturesList(competitionId: String) async throws -> FixturesResponse
}


class FixturesListService<Network: NetworkProtocol>: Serviceable where Network.Endpoint == API {
    private var network: Network
    
    // inject this for testability
    init(network: Network) {
        self.network = network
    }
    
    func fetchFixturesList(competitionId: String) async throws -> FixturesResponse {
        let endpoint = API.featchMatchesList(competitionId: competitionId)
        return try await network.request(endpoint: endpoint, responseType: FixturesResponse.self)
    }
}
