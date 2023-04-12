//
//  SecureSettingsItem.swift
//  Premier League
//
//  Created by Sherif Kamal on 05/04/2023.
//

import Foundation
import KeychainAccess

/// A property wrapper that uses Keychain as a backing store,

@propertyWrapper
struct SecureSettingsOptionalItem {

    /// The keychain storage
    let keychain: Keychain
    /// The key for the value in Keychain
    let key: String

    /// The value retreived from Keychain, if any exists
    var wrappedValue: String? {
        get {
            keychain[key]
        }
        set {
            if let newValue = newValue {
                keychain[key] = newValue
            } else {
                keychain[key] = nil
            }
        }
    }

    init(key: String) {
           
        self.keychain = Keychain.default
        self.key = key
    }
}

// MARK: - Default Keychain
extension Keychain {
    
    static var `default`: Keychain {
        if let bundleId = Bundle.main.bundleIdentifier {
            return Keychain(service: bundleId)
        } else {
            return Keychain()
        }
    }
}
