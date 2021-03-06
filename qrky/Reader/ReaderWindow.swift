//
//  ReaderWindow.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import AppKit
import SwiftUI

final class ReaderWindowController<RootView: View>: NSWindowController {
    convenience init(rootView: RootView) {
        let hostingController = NSHostingController(rootView: rootView)
        let window = ReaderWindow(contentViewController: hostingController)

        self.init(window: window)
    }
}

final class ReaderWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect,
                   styleMask: style,
                   backing: .buffered,
                   defer: false)

        level = .floating
        isMovable = true
        isMovableByWindowBackground = true
        backgroundColor = .clear

        disableFullScreen()
    }
}
