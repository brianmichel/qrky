//
//  AppDelegateCore.swift
//  QRky
//
//  Created by Brian Michel on 6/14/22.
//

import AppKit
import ComposableArchitecture
import Combine

struct AppDelegateState: Equatable {}
struct AppDelegateEnvironment: Equatable {}

enum AppDelegateAction {
    case willFinishLaunching(Notification)
}

let appDelegateReducer = Reducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment>.combine(
    Reducer { state, action, envionment in
        switch action {
        case .willFinishLaunching:
            NSWindow.allowsAutomaticWindowTabbing = false
            return .none
        }
    }
)
