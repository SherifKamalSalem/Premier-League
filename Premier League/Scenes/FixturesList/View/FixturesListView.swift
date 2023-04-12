//
//  FixturesListView.swift
//  Premier League
//
//  Created by Sherif Kamal on 08/04/2023.
//

import SwiftUI

struct FixturesListView<ViewModel: FixturesListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationBarTitle("Fixtures".localized)
                .navigationBarItems(trailing: toggleFavoritesOnlyButton)
                .task {
                    await viewModel.loadFixtures()
                }
        }
    }
    
    private var content: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .empty:
                emptyResultView
            case .finished:
                fixturesList
            default:
                emptyResultView
            }
        }
    }
    
    private var fixturesList: some View {
        List {
            let fixtures = viewModel.fixturesByDate
            ForEach(fixtures, id: \.self) { fixturesByDate in
                if let date = DateFormatter.formatUTCDateToString(fixturesByDate.date) {
                    if viewModel.shouldShowSection(fixturesByDate) {
                        Section(header: Text(date)) {
                            ForEach(fixturesByDate.fixtures.filter(shouldShowFixtureRow)) { fixture in
                                FixtureRowView(
                                    fixture: fixture,
                                    isFavorite: viewModel.isFavorite(fixture),
                                    toggleFavorite: { viewModel.toggleFavorite(for: fixture) }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func shouldShowFixtureRow(for fixture: FixtureRowViewModel) -> Bool {
        !viewModel.showFavoritesOnly || viewModel.isFavorite(fixture)
    }
    
    private var toggleFavoritesOnlyButton: some View {
        Toggle(isOn: $viewModel.showFavoritesOnly) {
            Text("favorites_only".localized)
        }
        .toggleStyle(SwitchToggleStyle(tint: .blue))
    }
    
    var emptyResultView: some View {
        NavigationView {
            AnyView(Text("No results")
                .font(.largeTitle)
                .foregroundColor(.gray))
        }
        .navigationBarTitle("Fixture".localized)
    }
}

