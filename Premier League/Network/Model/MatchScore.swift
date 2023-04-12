//
//  MatchScore.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation

struct MatchScore: Decodable {
    let winner: Winner?
    let fullTime, halfTime, extraTime, penalties: MatchTime
}
    
