//
//  FixturesListViewModelTests.swift
//  Premier LeagueTests
//
//  Created by Sherif Kamal on 09/04/2023.
//

import XCTest
@testable import Premier_League

final class FixturesListViewModelTests: XCTestCase {
    
    // MARK: - Test Load Fixtures
    
    func testLoadFixturesSuccess() async throws {
        // Given
        let expectedFixturesByDate = makeMockFixturesByDate()
        let viewModel = makeSUT(stubbedFetchFixturesListResult: .success(makeFixturesResponse()))
       
        // When
        try await viewModel.loadFixtures()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.state, .finished)
        XCTAssertEqual(viewModel.fixturesByDate.first?.date, expectedFixturesByDate.date)
        XCTAssertEqual(viewModel.fixturesByDate.first?.fixtures, expectedFixturesByDate.fixtures)
    }
    
    func testLoadFixturesFailure() async throws {
        let error = NSError(domain: "Test Error", code: 0, userInfo: nil)
        let viewModel = makeSUT(stubbedFetchFixturesListResult: .failure(error))
        
        // When
        try await viewModel.loadFixtures()
        
        // Then
        XCTAssertEqual(viewModel.state, .showError(error: error))
        XCTAssertTrue(viewModel.fixturesByDate.isEmpty)
    }
    
    // MARK: - Test Toggle Favorite
    
    func testToggleFavoriteAdd() {
        let fixture = makeMockFixture()
        let viewModel = makeSUT()
        viewModel.toggleFavorite(for: fixture)
        XCTAssertTrue(viewModel.isFavorite(fixture))
    }
    
    func testToggleFavoriteRemove() {
        let fixture = makeMockFixture()
        let viewModel = makeSUT()
        viewModel.favoriteFixturesIds.insert(fixture.id)
        viewModel.toggleFavorite(for: fixture)
        XCTAssertFalse(viewModel.isFavorite(fixture))
    }
    
    // MARK: - Test Is Favorite
    
    func testIsFavoriteTrue() {
        let fixture = makeMockFixture()
        let viewModel = makeSUT()
        
        viewModel.favoriteFixturesIds.insert(fixture.id)
        XCTAssertTrue(viewModel.isFavorite(fixture))
    }
    
    func testIsFavoriteFalse() {
        let fixture = makeMockFixture()
        let viewModel = makeSUT()
        
        XCTAssertFalse(viewModel.isFavorite(fixture))
    }
    
    // MARK: - Test Load Favorite Fixtures
    
    func testLoadFavoriteFixtures() {
        let fixtureIds = [1, 2, 3]
        let viewModel = makeSUT()
        
        viewModel.favoriteFixturesIds = Set(fixtureIds)
        viewModel.loadFavoriteFixtures()
        XCTAssertEqual(viewModel.favoriteFixturesIds, Set(fixtureIds))
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
    
    private func makeFixturesResponse() -> FixturesResponse {
        return FixturesResponse(count: 2, matches: [makeMockFixture().fixtureInstance])
    }
    
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
