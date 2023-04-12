//
//  FixtureRowView.swift
//  Premier League
//
//  Created by Sherif Kamal on 08/04/2023.
//

import SwiftUI

struct FixtureRowView: View {
    let fixture: FixtureRowViewModel
    @State var isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                isFavorite.toggle()
                toggleFavorite()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .renderingMode(.template)
                    .foregroundColor(.yellow)
            }
            Spacer()
            HStack(alignment: .center) {
                Text(fixture.homeTeamName)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
                Spacer()
                
                Text(fixture.matchResult)
                    .border(.gray, width: 0.5)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Spacer()
                Text(fixture.awayTeamName)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
        }
    }
}
