//
//  NSWindow+Extensions.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import AppKit

extension NSWindow {
    func disableFullScreen() {
        collectionBehavior = [.fullScreenNone]
        let zoomButton = standardWindowButton(.zoomButton)
        zoomButton?.isEnabled = false
    }
}
