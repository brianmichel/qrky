//
//  GeneralSettingsView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

enum QRCodeCheckDelay: Int {
    case instant, slower, slowest

    var delay: Float {
        switch self {
        case .instant:
            return 0.0
        case .slower:
            return 0.5
        case .slowest:
            return 2.0
        }
    }
}

enum ScannerSuccessColor: Int {
    case green, blue

    var color: Color {
        switch self {
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}

struct GeneralSettingsView: View {
    @AppStorage("autoOpenScanner") private var autoLaunchScanner = false
    @AppStorage("qrCodeCheckDelay") private var qrCodeCheckDelay = QRCodeCheckDelay.instant
    @AppStorage("qrScanSuccessColor") private var anotherDropDown = ScannerSuccessColor.green

    var body: some View {
        VStack {
            Form {
                Toggle(isOn: $autoLaunchScanner, label: {
                    Text("Auto open scanner window")
                })
                Text("Automatically launch the scanner window when the app is launched.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    // Seems like we have to explicitly set the frame due to a layout issue.
                    .frame(width: 250)
                Picker("Success Color:", selection: $anotherDropDown) {
                    Text("Green").tag(ScannerSuccessColor.green)
                    Text("Blue").tag(ScannerSuccessColor.blue)
                }

                Spacer().frame(height: 20)
                Picker("Scanner delay:", selection: $qrCodeCheckDelay) {
                    Text("No Delay").tag(QRCodeCheckDelay.instant)
                    Text("Slow").tag(QRCodeCheckDelay.slower)
                    Text("Slowest").tag(QRCodeCheckDelay.slowest)
                }.pickerStyle(InlinePickerStyle())
                Text("Sometimes you might want to delay the recognition of a QR code until after the window has settled, this option lets you tune this preference.")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.padding(.horizontal)
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView().frame(width: 400)
    }
}
