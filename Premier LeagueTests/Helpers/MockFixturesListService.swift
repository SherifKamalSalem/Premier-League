//
//  MockFixturesListService.swift
//  Premier LeagueTests
//
//  Created by Sherif Kamal on 09/04/2023.
//

import Foundation
import Combine
@testable import Premier_League

class MockFixturesListService: Serviceable {
    var stubbedFetchFixturesListResult: Result<FixturesResponse, Error>
    
    init(stubbedFetchFixturesListResult: Result<FixturesResponse, Error>) {
        self.stubbedFetchFixturesListResult = stubbedFetchFixturesListResult
    }
    
    func fetchFixturesList(competitionId: String) async throws -> Premier_League.FixturesResponse {
        switch stubbedFetchFixturesListResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
