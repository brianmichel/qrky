//
//  QrkyAppDelegate.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import AppKit
import ComposableArchitecture

/// Create an AppDelegate to terminate the application when the last window is closed.
/// This is a hack around SwiftUI for the time being...
class QrkyAppDelegate: NSObject, NSApplicationDelegate {
    let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: .live
    )

    lazy var viewStore = ViewStore(
        self.store.scope(state: { _ in () }),
        removeDuplicates: ==
    )

    func applicationWillFinishLaunching(_ notification: Notification) {
        viewStore.send(.appDelegate(.willFinishLaunching(notification)))
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
