//
//  AppCore.swift
//  QRky
//
//  Created by Brian Michel on 6/14/22.
//
import AppKit
import ComposableArchitecture
import OrderedCollections

struct AppState: Equatable {
    var items = OrderedSet<DecodedItem>()
    var scannerShowing = false
}

struct AppEnvironment {
    var appDelegate: AppDelegateClient
    var pasteboard = PasteboardCopier()
    var notifier = Notifier()
    var scanner: ScannerClient = .live
}

enum AppAction {
    case appDelegate(AppDelegateClient.Action)
    case beginScanning
    case endScanning
    case copyToClipboard(DecodedItem)
    case scanner(Result<ScannerClient.Action, Never>)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .appDelegate(.willFinishLaunching):
            NSWindow.allowsAutomaticWindowTabbing = false
            return .none
        case .beginScanning:
            // begin scanning with client
            return environment.scanner.startScanning().catchToEffect(AppAction.scanner)
        case .endScanning:
            // end scanning with client
            return environment.scanner.stopScanning().catchToEffect(AppAction.scanner)
        case let .copyToClipboard(item):
            environment.pasteboard.copy(string: item.value)
            environment.notifier.notify(for: item, storage: state.items)
            return .none
        case let .scanner(.success(.decodedCode(item))):
            environment.notifier.notify(for: item, storage: state.items)
            state.items.insert(item, at: 0)
            environment.pasteboard.copy(string: item.value)
            return .none
        }
    }
)

extension AppEnvironment {
    static var live: Self {
        return .init(appDelegate: .live)
    }
}
