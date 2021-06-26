//
//  qrkyApp.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

/// Create an AppDelegate to terminate the application when the last window is closed.
/// This is a hack around SwiftUI for the time being...
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct qrkyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }

        Settings {
            VStack {
                Text("Settings Go Here").padding()
            }
        }
    }
}
