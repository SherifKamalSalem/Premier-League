//
//  APIService.swift
//  Premier League
//
//  Created by Sherif Kamal on 06/04/2023.
//

import Moya
import Combine
import Foundation
import CombineMoya


protocol NetworkProtocol: AnyObject {
    associatedtype Endpoint
    
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T
}
