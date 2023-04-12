//
//  FetchState.swift
//  Premier League
//
//  Created by Sherif Kamal on 12/04/2023.
//

import Foundation

enum FetchState: Equatable {
    case finished
    case ideal
    case loading
    case empty
    case showError(error: Error)
    
    static func == (lhs: FetchState, rhs: FetchState) -> Bool {
        switch (lhs, rhs) {
        case (.finished, .finished): return true
        case (.loading, .loading): return true
        case (.empty, .empty): return true
        case (.ideal, .ideal): return true
        case (.showError, .showError): return true
        default: return false
        }
    }
}
