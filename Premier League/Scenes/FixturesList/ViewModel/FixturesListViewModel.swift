//
//  MatchesListViewModel.swift
//  Premier League
//
//  Created by Sherif Kamal on 07/04/2023.
//


import Foundation
import Combine

protocol FixturesListViewModelProtocol: AnyObject, ObservableObject {
    func loadFixtures()
    func toggleFavorite(for fixture: FixtureRowViewModel)
    func loadFavoriteFixtures()
    func shouldShowSection(_ fixturesByDate: FixturesByDate) -> Bool
    func sortedFixturesByDate(_ fixtures: [FixtureRowViewModel]) -> [FixturesByDate]
    func isFavorite(_ fixture: FixtureRowViewModel) -> Bool
    var fixturesByDate: [FixturesByDate] { get }
    var favoriteFixturesIds: Set<Int> { get set }
    var showFavoritesOnly: Bool { get set }
    var state: CurrentValueSubject<FetchState, Never> { get set }
    var errorMessage: CurrentValueSubject<String, Never> { get }
}


class FixturesListViewModel {
    private let service: Serviceable
    private var cancellables = Set<AnyCancellable>()
    
    @Published var fixturesByDate = [FixturesByDate]()
    
    init(service: Serviceable) {
        self.service = service
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
}
