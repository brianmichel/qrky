//
//  WindowReader.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import Foundation
import AppKit

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

final class WindowReader: ObservableObject {
    @Published var windows: [Window] = []

    init() {
        refreshWindows()
    }

    func screenshot(window id: CGWindowID) -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(.null, [.optionIncludingWindow], id, [.bestResolution, .boundsIgnoreFraming]) else {
            return nil
        }

        let image = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))

        return image
    }

    func screenshot(bounds: CGRect) -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(bounds,
                                                    [],
                                                    kCGNullWindowID,
                                                    [.bestResolution]) else {
            return nil
        }

        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        let image = NSImage()
        image.addRepresentation(bitmap)

        return image
    }

    func refreshWindows() {
        guard let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? Array<Dictionary<String, Any>> else {
            return
        }

        self.windows = windows.compactMap { dictionary -> Window? in
            do {
                let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                let window = try JSONDecoder().decode(Window.self, from: data)

                return window
            } catch {
                return nil
            }
        }
    }
}
