//
//  ReaderView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI
import Combine

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
        .alert(isPresented: $model.showCopySheet, content: {
            Alert(title: Text("Decoded QR Code"),
                  message: Text("Found decoded value '\(firstCode())'. Would you like to copy it to the clipboard?"),
                  primaryButton: .default(Text("Copy"), action: {
                    model.manuallyCopy(item: firstCode())
                  }),
                  secondaryButton: .cancel(Text("Dismiss"), action: {
                    model.clearCodes()
                  }))
        })
    }

    private func borderColor() -> Color {
        model.codes.count > 0 ? qrScanSuccessColor.color : .red
    }

    private func firstCode() -> String {
        return model.codes.first ?? ""
    }
}

struct ReaderView_Previews: PreviewProvider {
    static let subject = PassthroughSubject<String, Never>()
    static let model = ReaderViewModel(foundCodeSubject: subject)

    static var previews: some View {
        ReaderView(model: model)
    }
}
