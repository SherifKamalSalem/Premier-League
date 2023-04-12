//
//  MatchesListViewModel.swift
//  Premier League
//
//  Created by Sherif Kamal on 07/04/2023.
//


import Foundation
import Combine

protocol FixturesListViewModelProtocol: AnyObject, ObservableObject {
    func loadFixtures() async
    func toggleFavorite(for fixture: FixtureRowViewModel)
    func loadFavoriteFixtures()
    func shouldShowSection(_ fixturesByDate: FixturesByDate) -> Bool
    func sortedFixturesByDate(_ fixtures: [FixtureRowViewModel]) -> [FixturesByDate]
    func isFavorite(_ fixture: FixtureRowViewModel) -> Bool
    var fixturesByDate: [FixturesByDate] { get }
    var favoriteFixturesIds: Set<Int> { get set }
    var showFavoritesOnly: Bool { get set }
    var state: FetchState { get set }
    var errorMessage: String { get }
}

class FixturesListViewModel: FixturesListViewModelProtocol {
    private let service: Serviceable
    private let userDefaults: UserDefaults
    private let favoriteFixturesKey = "favoriteFixtures"
    
    @Published var fixturesByDate = [FixturesByDate]()
    var favoriteFixturesIds = Set<Int>()
    @Published var showFavoritesOnly = false
    var errorMessage = ""
    @Published var state: FetchState = .ideal
    
    init(service: Serviceable, userDefaults: UserDefaults) {
        self.service = service
        self.userDefaults = userDefaults
        loadFavoriteFixtures()
    }
    
    // I hardcoded the `competitionId` here just for simplicity but it has to be entered by the user
    func loadFixtures() async {
        DispatchQueue.main.async {
            self.state = .loading
        }
        do {
            let response = try await service.fetchFixturesList(competitionId: "2021")
            let fixtures = response.matches
            let fixturesByDate = sortedFixturesByDate(fixtures.map(FixtureRowViewModel.init))
            updateFixtures(fixturesByDate: fixturesByDate, state: fixturesByDate.isEmpty ? .empty : .finished, errorMessage: "")
        } catch {
            updateFixtures(fixturesByDate: [], state: .showError(error: error), errorMessage: error.localizedDescription)
        }
    }
    
    func toggleFavorite(for fixture: FixtureRowViewModel) {
        if favoriteFixturesIds.contains(fixture.id) {
            favoriteFixturesIds.remove(fixture.id)
        } else {
            favoriteFixturesIds.insert(fixture.id)
        }
        userDefaults.set(Array(favoriteFixturesIds), forKey: favoriteFixturesKey)
    }
    
    func isFavorite(_ fixture: FixtureRowViewModel) -> Bool {
        favoriteFixturesIds.contains(fixture.id)
    }
    
    func loadFavoriteFixtures() {
        if let favoriteFixtureIds = userDefaults.array(forKey: favoriteFixturesKey) as? [Int] {
            favoriteFixturesIds = Set(favoriteFixtureIds)
        }
    }
    
    private func handleStoringFutureFixtures(_ sortedFutureFixtures: [FixtureRowViewModel], _ fixturesByDate: inout [FixturesByDate]) {
        if !sortedFutureFixtures.isEmpty {
            let fixturesDictionary = Dictionary(grouping: sortedFutureFixtures) { fixture -> Date in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: fixture.utcDate)
                return Calendar.current.date(from: components)!
            }
            let sortedDates = fixturesDictionary.keys.sorted()
            fixturesByDate = sortedDates.map { date -> FixturesByDate in
                let fixtures = fixturesDictionary[date] ?? []
                return FixturesByDate(date: date, fixtures: fixtures)
            }
        }
    }
    
    private func handleStoringPastFixtures(_ sortedPastFixtures: [FixtureRowViewModel], _ fixturesByDate: inout [FixturesByDate]) {
        if !sortedPastFixtures.isEmpty {
            let fixturesDictionary = Dictionary(grouping: sortedPastFixtures) { past -> Date in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: past.utcDate)
                return Calendar.current.date(from: components)!
            }
            let sortedDates = fixturesDictionary.keys.sorted().reversed()
            fixturesByDate.append(contentsOf: sortedDates.map { date -> FixturesByDate in
                let fixtures = fixturesDictionary[date] ?? []
                return FixturesByDate(date: date, fixtures: fixtures)
            })
        }
    }
    
    func sortedFixturesByDate(_ fixtures: [FixtureRowViewModel]) -> [FixturesByDate] {
        var fixturesByDate: [FixturesByDate] = []
        
        let currentDate = Date()
        let pastFixtures = fixtures.filter { $0.utcDate < currentDate }
        let futureFixtures = fixtures.filter { $0.utcDate >= currentDate }
        
        let sortedPastFixtures = pastFixtures.sorted(by: { $0.utcDate < $1.utcDate })
        let sortedFutureFixtures = futureFixtures.sorted(by: { $0.utcDate < $1.utcDate })
        
        handleStoringFutureFixtures(sortedFutureFixtures, &fixturesByDate)
        
        handleStoringPastFixtures(sortedPastFixtures, &fixturesByDate)
        return fixturesByDate
    }
    
    private func updateFixtures(
        fixturesByDate: [FixturesByDate],
        state: FetchState,
        errorMessage: String) {
        self.fixturesByDate = fixturesByDate
        self.state = state
        self.errorMessage = errorMessage
    }
    
    func shouldShowSection(_ fixturesByDate: FixturesByDate) -> Bool {
        if showFavoritesOnly {
             return fixturesByDate.fixtures.contains(where: { isFavorite($0) })
        } else {
            return !fixturesByDate.fixtures.isEmpty
        }
    }
}
