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

protocol NetworkProvider {
    associatedtype RequestType
    associatedtype ResponseType
    func request(_ request: RequestType) -> AnyPublisher<ResponseType, Error>
}

class MoyaNetworkProvider<RequestType: TargetType, ResponseType: Decodable>: NetworkProvider {
    let provider = MoyaProvider<RequestType>()
    
    func request(_ request: RequestType) -> AnyPublisher<ResponseType, Error> {
        return provider.requestPublisher(request)
            .tryMap { response in
                try response.map(ResponseType.self)
            }
            .mapError { error in
                error as Error
            }
            .eraseToAnyPublisher()
    }
}
