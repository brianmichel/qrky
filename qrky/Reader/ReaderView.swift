//
//  ReaderView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct ReaderView: View {
    @AppStorage(PreferenceKeys.qrScanSuccessColor) private var qrScanSuccessColor = ScannerSuccessColor.green

    private enum Constants {
        static let minDimension: CGFloat = 300
        static let maxDimension: CGFloat = 600
        static let borderWidth: CGFloat = 10
    }
    @ObservedObject var model: ReaderViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(minWidth: Constants.minDimension,
                       maxWidth: Constants.maxDimension,
                       minHeight: Constants.minDimension,
                       maxHeight: Constants.maxDimension)
                .border(borderColor(), width: Constants.borderWidth)
                .animation(.easeInOut(duration: 0.3))
        }
    }

    func borderColor() -> Color {
        model.codes.count > 0 ? qrScanSuccessColor.color : .red
    }
}

struct ReaderView_Previews: PreviewProvider {
    static let model = ReaderViewModel()

    static var previews: some View {
        ReaderView(model: model)
    }
}
