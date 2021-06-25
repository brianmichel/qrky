//
//  Window.swift
//  QRky
//
//  Created by Brian Michel on 6/25/21.
//

import Foundation

struct WindowRect: Codable, Identifiable, Hashable {
    var id = UUID()

    let x: Float
    let y: Float
    let height: Float
    let width: Float

    private enum CodingKeys: String, CodingKey {
        case x = "X"
        case y = "Y"
        case height = "Height"
        case width = "Width"
    }
}

struct Window: Codable, Identifiable, Hashable {
    let id = UUID()

    let pid: Int
    let memoryUsage: Int
    let windowLayer: Int
    let sharingState: Int
    let ownerName: String
    let number: CGWindowID
    let bounds: WindowRect

    private enum CodingKeys: String, CodingKey {
        case pid = "kCGWindowOwnerPID"
        case memoryUsage = "kCGWindowMemoryUsage"
        case windowLayer = "kCGWindowLayer"
        case sharingState = "kCGWindowSharingState"
        case ownerName = "kCGWindowOwnerName"
        case number = "kCGWindowNumber"
        case bounds = "kCGWindowBounds"
    }
}

