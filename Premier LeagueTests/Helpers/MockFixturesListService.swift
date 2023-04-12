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
    
    func fetchFixturesList(competitionId: String) -> AnyPublisher<FixturesResponse, Error> {
        switch stubbedFetchFixturesListResult {
        case .success(let response):
            return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
