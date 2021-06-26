//
//  EmptyHomeView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

struct EmptyHomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Label("No Scans Found", systemImage: "qrcode.viewfinder").font(.largeTitle)
            Text("Scan a QR code and it will show up here until you quit the application.")
        }.padding().foregroundColor(.secondary)
    }
}

struct EmptyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHomeView()
    }
}
