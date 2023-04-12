//
//  Fixture.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation

struct Fixture: Decodable {
    
    var id: Int
    var utcDate: Date
    var status: FixtureStatus?
    var matchday: Int?
    var stage: String?
    var group: String?
    
    var homeTeam: Team?
    var awayTeam: Team?
    
    var score: MatchScore
}

enum FixtureStatus: String, Decodable {
    case POSTPONED
    case FINISHED
    case SCHEDULED
    case IN_PLAY
}
