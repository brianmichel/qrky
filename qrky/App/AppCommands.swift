//
//  AppCommands.swift
//  QRky
//
//  Created by Brian Michel on 6/14/22.
//

import ComposableArchitecture
import SwiftUI

final class AppCommands: Commands {
    var store: Store<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
    }

    var body: some Commands {
        WithViewStore(store) { viewStore in
            CommandGroup(replacing: CommandGroupPlacement.newItem, addition: {})
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button(action: {
                    viewStore.send(.beginScanning)
                }, label: {
                    Text("Open Scanner")
                }).keyboardShortcut(KeyEquivalent("s"))
            }
            CommandGroup(replacing: CommandGroupPlacement.undoRedo, addition: {})
        }
    }
}
