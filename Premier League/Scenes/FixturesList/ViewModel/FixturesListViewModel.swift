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


class FixturesListViewModel: FixturesListViewModelProtocol {
    private let service: Serviceable
    private let userDefaults: UserDefaults
    private var cancellables = Set<AnyCancellable>()
    private let favoriteFixturesKey = "favoriteFixtures"
    
    @Published var fixturesByDate = [FixturesByDate]()
    var favoriteFixturesIds = Set<Int>()
    var state = CurrentValueSubject<FetchState, Never>(.ideal)
    var showError = CurrentValueSubject<Bool, Never>(false)
    @Published var showFavoritesOnly = false
    var errorMessage = CurrentValueSubject<String, Never>("")
    
    init(service: Serviceable, userDefaults: UserDefaults) {
        self.service = service
        self.userDefaults = userDefaults
        loadFixtures()
        loadFavoriteFixtures()
    }
    
    // I hardcoded the `competitionId` here just for simplicity but it has to be entered by the user
    func loadFixtures() {
        self.state.value = .loading
        service.fetchFixturesList(competitionId: "2021")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.updateFixtures(fixturesByDate: [], state: .showError(error: error), errorMessage: error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                let fixtures = response.matches
                let fixturesByDate = sortedFixturesByDate(fixtures.map(FixtureRowViewModel.init))
                self.updateFixtures(fixturesByDate: fixturesByDate, state: fixturesByDate.isEmpty ? .empty : .finished, errorMessage: "")
            })
            .store(in: &cancellables)
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
        self.state.value = state
        self.errorMessage.value = errorMessage
    }
    
    func shouldShowSection(_ fixturesByDate: FixturesByDate) -> Bool {
        if showFavoritesOnly {
             return fixturesByDate.fixtures.contains(where: { isFavorite($0) })
        } else {
            return !fixturesByDate.fixtures.isEmpty
        }
    }
}
