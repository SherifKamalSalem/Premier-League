//
//  NetworkManager.swift
//  Premier League
//
//  Created by Sherif Kamal on 12/04/2023.
//

import Foundation
import CombineMoya
import Moya
import Combine

final class NetworkManager<U: TargetType>: NetworkProtocol {
    private let provider: MoyaProvider<U>
    private let decoder: JSONDecoder
    
    init(provider: MoyaProvider<U>, decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }
    
    func request<T: Decodable>(endpoint: U, responseType: T.Type) -> AnyPublisher<T, Error> {
        provider.requestPublisher(endpoint)
            .mapError { $0 as Error }
            .flatMap { response -> AnyPublisher<T, Error> in
                do {
                    let data = try response.map(responseType, using: self.decoder)
                    return Just(data)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
