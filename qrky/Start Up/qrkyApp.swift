//
//  qrkyApp.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

@main
struct qrkyApp: App {
    let model = HomeViewModel()

    @NSApplicationDelegateAdaptor(QrkyAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView(model: model)
        }.commands {
            model.commands
        }

        Settings {
            VStack {
                Text("Settings Go Here").padding()
            }
        }
    }
}
