//
//  FixturesByDate.swift
//  Premier League
//
//  Created by Sherif Kamal on 12/04/2023.
//

import Foundation

struct FixturesByDate: Hashable {
    var date: Date
    var fixtures: [FixtureRowViewModel]
}
