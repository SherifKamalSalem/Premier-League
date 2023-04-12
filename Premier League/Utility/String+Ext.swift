//
//  String+Ext.swift
//  Premier League
//
//  Created by Sherif Kamal on 11/04/2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}
