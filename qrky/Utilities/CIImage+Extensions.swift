//
//  CIImage+Extensions.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import CoreImage

extension CIImage {
    // Adapted from https://github.com/EFPrefix/EFQRCode/blob/165c0cf7e551d33e69b86694d0ae2ed71ade6c6e/Source/CIImage%2B.swift
    func qrCodes() -> [String] {
        var results = [String]()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [:])
        guard let features = detector?.features(in: self) else {
            return results
        }

        results = features.compactMap({ feature in
            (feature as? CIQRCodeFeature)?.messageString
        })

        return results
    }
}
