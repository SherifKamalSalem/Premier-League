//
//  Secrets.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation

final class Secret {
        
    var value: String {
        
        let decoded = encoded.enumerated().map { offset, element in
            element ^ cipher[offset]
        }
        return String(decoding: decoded, as: UTF8.self)
    }
        
    private let encoded: [UInt8]
    private let cipher: [UInt8]
    
    required init(
        encoded: [UInt8],
        cipher: [UInt8]) {
        
        self.encoded = encoded
        self.cipher = cipher
    }
}
