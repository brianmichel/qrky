//
//  DecodedItem.swift
//  QRky
//
//  Created by Brian Michel on 6/25/21.
//

import Foundation

struct DecodedItem: Hashable, Identifiable {
    var id: String {
        return value
    }

    let date = Date()
    let value: String

    static func ==(lhs: DecodedItem, rhs: DecodedItem) -> Bool {
        // We don't really care about the date for comparison, just the value.
        return lhs.value == rhs.value
    }
}
