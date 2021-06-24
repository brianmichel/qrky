//
//  NSImage+Extensions.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import Foundation

// Adapted from https://github.com/EFPrefix/EFQRCode/blob/165c0cf7e551d33e69b86694d0ae2ed71ade6c6e/Source/NSImage%2B.swift
import AppKit
import CoreImage

extension NSImage {
    func ciImage() -> CIImage? {
        return self.tiffRepresentation(using: .none, factor: 0).flatMap(CIImage.init)
    }

    func cgImage() -> CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil) ?? ciImage()?.cgImage
    }
}
