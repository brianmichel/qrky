//
//  View+Extensions.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

extension View {
    func inWindowController() -> NSWindowController {
        let hostingController = NSHostingController(rootView: self)
        let window = NSWindow(contentViewController: hostingController)

        return NSWindowController(window: window)
    }
}
