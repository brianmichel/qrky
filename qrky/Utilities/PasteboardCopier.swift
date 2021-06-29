//
//  PasteboardCopier.swift
//  QRky
//
//  Created by Brian Michel on 6/28/21.
//

import AppKit

struct PasteboardCopier {
    let clearOnCopy: Bool
    private let pasteboard = NSPasteboard.general

    init(clearOnCopy: Bool = true) {
        self.clearOnCopy = clearOnCopy
    }

    func copy(string value: String) {
        if clearOnCopy {
            pasteboard.clearContents()
        }

        pasteboard.setString(value, forType: .string)
    }
}
