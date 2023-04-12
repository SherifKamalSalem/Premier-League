//
//  FixturesResponse.swift
//  Premier League
//
//  Created by Sherif Kamal on 09/04/2023.
//

struct FixturesResponse: Decodable {
    let count: Int?
    let matches: [Fixture]
}
