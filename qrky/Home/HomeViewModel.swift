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
import UserNotifications

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
    private let notifier = Notifier()
    private let copier = PasteboardCopier()
    private let actioner = Actioner()


    private var storage = Set<AnyCancellable>()

    let commands = HomeViewModelCommands()

    init() {
        readerModel.foundCodeSubject.sink { [weak self] code in
            guard let self = self else {
                return
            }

            let item = DecodedItem(value: code)

            // Note: These next two lines are order dependent, we want to record
            // seeing the item after we potentially notify
            self.notifier.notify(for: item, storage: self.decodedItems)
            self.decodedItems.insert(item, at: 0)
            self.copier.copy(string: item.value)
            self.actioner.action(item: item)
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

    func copyToClipboard(item: DecodedItem) {
        copier.copy(string: item.value)
        notifier.notify(for: item, storage: decodedItems)
    }
}
