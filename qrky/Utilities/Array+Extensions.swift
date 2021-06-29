//
//  Array+Extensions.swift
//  QRky
//
//  Created by Brian Michel on 6/29/21.
//

import Foundation

// From https://newbedev.com/swiftui-what-is-appstorage-property-wrapper
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
