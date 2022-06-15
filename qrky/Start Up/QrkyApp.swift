//
//  qrkyApp.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import Combine
import SwiftUI

@main
struct QrkyApp: App {

    @NSApplicationDelegateAdaptor(QrkyAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView(store: appDelegate.store)
        }.commands {
           // AppCommands(store: appDelegate.store)
        }

        Settings {
            SettingsView()
        }
    }
}
