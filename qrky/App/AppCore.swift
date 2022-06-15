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
    var appDelegate: AppDelegateState = .init()
}

struct AppEnvironment {
    var pasteboard = PasteboardCopier()
    var notifier = Notifier()
    var scanner: ScannerClient = .live
    var appDelegate: AppDelegateEnvironment = .init()
}

enum AppAction {
    case appDelegate(AppDelegateAction)
    case beginScanning
    case endScanning
    case copyToClipboard(DecodedItem)
    case scanner(Result<ScannerClient.Action, Never>)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    appDelegateReducer.pullback(
        state: \.appDelegate,
        action: /AppAction.appDelegate,
        environment: \.appDelegate),
    Reducer { state, action, environment in
        switch action {
        case .appDelegate:
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
        return .init()
    }
}
