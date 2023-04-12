//
//  FixtureRowViewModel.swift
//  Premier League
//
//  Created by Sherif Kamal on 12/04/2023.
//

import Foundation

class FixtureRowViewModel: ObservableObject, Identifiable {
    private let fixture: Fixture
    
    var id: Int {
        fixture.id
    }
    
    var utcDate: Date {
        fixture.utcDate
    }
    
    var status: FixtureStatus? {
        fixture.status
    }
    
    var matchday: Int? {
        fixture.matchday
    }
    
    var stage: String? {
        fixture.stage
    }
    
    var group: String? {
        fixture.group
    }
    
    var homeTeamName: String {
        fixture.homeTeam?.name ?? ""
    }
    
    var awayTeamName: String {
        fixture.awayTeam?.name ?? ""
    }
    
    var score: MatchScore {
        fixture.score
    }
    
    var matchResult: String {
        if status == .FINISHED {
            if let homeTeamGoals = score.fullTime.homeTeam,
               let awayTeamGoals = score.fullTime.awayTeam {
                return "\(homeTeamGoals) - \(awayTeamGoals)"
            }
        } else if let date = DateFormatter.formatUTCTimeToString(utcDate) {
            return date
        }
        return ""
    }
    
    init(fixture: Fixture) {
        self.fixture = fixture
    }
}

extension FixtureRowViewModel: Hashable {
    static func == (lhs: FixtureRowViewModel, rhs: FixtureRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
