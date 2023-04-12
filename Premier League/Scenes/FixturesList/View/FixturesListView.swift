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
        }
    }
    
    private var content: some View {
        Group {
            fixturesList
        }
    }
    
    private var fixturesList: some View {
        List {
            
        }
    }
}

