//
//  ContentView.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import SwiftUI
import Moya

struct ContentView: View {
    let provider = MoyaProvider<API>()
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    var body: some View {
        FixturesListView(viewModel: FixturesListViewModel(service: FixturesListService(network: NetworkManager(provider: provider, decoder: decoder)), userDefaults: UserDefaults.standard))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
