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
