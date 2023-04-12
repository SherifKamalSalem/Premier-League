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
    
    func testLoadFixturesSuccess() {
        // Given
        let expectedFixturesByDate = makeMockFixturesByDate()
        let expectation = XCTestExpectation(description: "Fetch fixtures")
        var cancellables = Set<AnyCancellable>()
        
        let viewModel = makeSUT(stubbedFetchFixturesListResult: .success(makeFixturesResponse()))
       
        // When
        viewModel.loadFixtures()
        
        viewModel.state.dropFirst().sink { state in
            XCTAssertEqual(state, .finished)
            XCTAssertEqual(viewModel.fixturesByDate.first?.date, expectedFixturesByDate.date)
            XCTAssertEqual(viewModel.fixturesByDate.first?.fixtures, expectedFixturesByDate.fixtures)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertEqual(viewModel.errorMessage.value, "")
    }
    
    private func makeSUT(stubbedFetchFixturesListResult: Result<FixturesResponse, Error> = .success(FixturesResponse(count: nil, matches: [])), file: StaticString = #file, line: UInt = #line) -> any FixturesListViewModelProtocol {
        let viewModel = FixturesListViewModel(service: MockFixturesListService(stubbedFetchFixturesListResult: stubbedFetchFixturesListResult), userDefaults: MockUserDefaults())
        trackForMemoryLeaks(viewModel, file: file, line: line)
        return viewModel
    }
    
    private func makeMockFixture() -> FixtureRowViewModel {
        let fixture = Fixture(id: 1, utcDate: DateFormatter.dateFormat("2023-04-15T14:00:00Z") ?? Date(), status: .FINISHED, homeTeam: Team(id: 1, name: "Arsenal"), awayTeam: Team(id: 2, name: "Chelsea"), score: MatchScore(winner: .awayTeam, fullTime: .init(homeTeam: 0, awayTeam: 2), halfTime: .init(homeTeam: nil, awayTeam: nil), extraTime: .init(homeTeam: nil, awayTeam: nil), penalties: .init(homeTeam: nil, awayTeam: nil)))
        return FixtureRowViewModel(fixture: fixture)
    }
//
    private func makeFixturesResponse() -> FixturesResponse {
        return FixturesResponse(count: 2, matches: [makeMockFixture().fixtureInstance])
    }
//
    private func makeMockFixturesByDate() -> FixturesByDate {

        return FixturesByDate(date: DateFormatter.dateFormat("2023-04-14T22:00:00Z") ?? Date(), fixtures: [makeMockFixture()])

    }
}

class MockUserDefaults: UserDefaults {
    var arrayForKeyResult: [Any]?
    
    override func array(forKey defaultName: String) -> [Any]? {
        return arrayForKeyResult
    }
}
