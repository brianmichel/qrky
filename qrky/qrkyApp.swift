//
//  qrkyApp.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

@main
struct qrkyApp: App {
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
