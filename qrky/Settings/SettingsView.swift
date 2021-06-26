//
//  SettingsView.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, about
    }

    private enum Constants {
        static let minWidth: CGFloat = 300
        static let maxWidth: CGFloat = 400
        static let minHeight: CGFloat = 300
        static let maxHeight: CGFloat = 400
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
            .tabItem { Label("General", systemImage: "qrcode") }
            .tag(Tabs.general)
            AboutSettingsView()
            .tabItem { Label("About", systemImage: "text.book.closed") }
            .tag(Tabs.about)
        }
        .frame(minWidth: Constants.minWidth,
               maxWidth: Constants.maxWidth,
               minHeight: Constants.minHeight,
               maxHeight: Constants.maxHeight,
               alignment: .center)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
