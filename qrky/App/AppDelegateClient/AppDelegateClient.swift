//
//  AppDelegateClient.swift
//  QRky
//
//  Created by Brian Michel on 6/14/22.
//

import ComposableArchitecture
import Combine

struct AppDelegateClient {
    var willFinishLaunching: (Notification) -> Effect<Action, Never>

    enum Action: Equatable {
        case willFinishLaunching(Notification)
    }
}

extension AppDelegateClient {
    static var live: Self {
        return .init(
            willFinishLaunching: { notification in
                    .run { subscriber in
                        subscriber.send(.willFinishLaunching(notification))
                        subscriber.send(completion: .finished)

                        return AnyCancellable {}
                    }
        })
    }
}
