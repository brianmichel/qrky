//
//  HostingWindowFinder.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

// Adapted from https://stackoverflow.com/questions/66020611/swiftui-2-0-disable-windows-zoom-button-on-macos
struct HostingWindowFinder: NSViewRepresentable {
    func updateNSView(_ nsView: NSView, context: Context) {
        // Do Nothing
    }

    var callback: (NSWindow?) -> ()

    func makeNSView(context: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        view.bounds = CGRect.zero
        return view
    }
}
