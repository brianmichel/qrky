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

    var body: some View {
        TabView {
            GeneralSettingsView()
            .tabItem { Label("General", systemImage: "qrcode") }
            .tag(Tabs.general)
            AboutSettingsView()
            .tabItem { Label("About", systemImage: "text.book.closed") }
            .tag(Tabs.about)
        }.frame(minWidth: 200, idealWidth: 200, maxWidth: 400, minHeight: 200, idealHeight: 200, maxHeight: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
