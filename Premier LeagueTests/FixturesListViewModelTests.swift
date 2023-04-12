//
//  FixturesListViewModelTests.swift
//  Premier LeagueTests
//
//  Created by Sherif Kamal on 09/04/2023.
//

import XCTest
import Combine
@testable import Premier_League

final class FixturesListViewModelTests: XCTestCase {
    
    // MARK: - Test Load Fixtures
    
    private func makeSUT(stubbedFetchFixturesListResult: Result<FixturesResponse, Error> = .success(FixturesResponse(count: nil, matches: [])), file: StaticString = #file, line: UInt = #line) -> any FixturesListViewModelProtocol {
        let viewModel = FixturesListViewModel(service: MockFixturesListService(stubbedFetchFixturesListResult: stubbedFetchFixturesListResult), userDefaults: MockUserDefaults())
        trackForMemoryLeaks(viewModel, file: file, line: line)
        return viewModel
    }
}

class MockUserDefaults: UserDefaults {
    var arrayForKeyResult: [Any]?
    
    override func array(forKey defaultName: String) -> [Any]? {
        return arrayForKeyResult
    }
}
