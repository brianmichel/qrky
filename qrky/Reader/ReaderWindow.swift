//
//  ReaderWindow.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import AppKit
import SwiftUI

final class ReaderWindow: NSWindow {
    class func windowController() -> NSWindowController {
        let hostingController = NSHostingController(rootView: ReaderView())
        let window = ReaderWindow(contentViewController: hostingController)

        return NSWindowController(window: window)
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        isOpaque = false
        backgroundColor = .clear

        print("WINDOW NUMBER: \(windowNumber)")
    }
}
