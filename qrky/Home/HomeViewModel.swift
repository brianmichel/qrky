//
//  HomeViewModel.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import Foundation
import SwiftUI
import OrderedCollections
import Combine

final class HomeViewModelCommands: Commands {
    var openScannerClicked: (() -> Void)?

    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.newItem, addition: {})
        CommandGroup(after: CommandGroupPlacement.newItem) {
            Button(action: {
                self.openScannerClicked?()
            }, label: {
                Text("Open Scanner")
            }).keyboardShortcut(KeyEquivalent("s"))
        }
        CommandGroup(replacing: CommandGroupPlacement.undoRedo, addition: {})
    }
}

final class HomeViewModel: ObservableObject {
    @Published var decodedItems = OrderedSet<DecodedItem>()

    private let readerModel = ReaderWindowModel()

    private var storage = Set<AnyCancellable>()

    let commands = HomeViewModelCommands()

    init() {
        readerModel.foundCodeSubject.sink { [weak self] code in
            self?.decodedItems.insert(DecodedItem(value: code), at: 0)
        }.store(in: &storage)

        commands.openScannerClicked = { [weak self] in
            self?.showReader()
        }
    }

    func showReader() {
        readerModel.show()
    }

    func hideReader() {
        readerModel.hide()
    }
}
