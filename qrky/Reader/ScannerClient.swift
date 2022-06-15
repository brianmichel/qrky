//
//  ScannerClient.swift
//  QRky
//
//  Created by Brian Michel on 6/14/22.
//

import ComposableArchitecture
import Combine

struct ScannerClient {
    var startScanning: () -> Effect<Action, Never>
    var stopScanning: () -> Effect<Action, Never>

    enum Action: Equatable {
        case decodedCode(DecodedItem)
    }
}

extension ScannerClient {
    static var live: Self {
        let model = ReaderWindowModel()
        var cancellables = Set<AnyCancellable>()

        return .init(startScanning: {
            .run { subscriber in
                model.show()

                model.foundCodeSubject.sink { code in
                    subscriber.send(.decodedCode(DecodedItem(value: code)))
                }
                .store(in: &cancellables)

                return AnyCancellable {
                    cancellables = Set<AnyCancellable>()
                }
            }

        }, stopScanning: {
            .fireAndForget {
                model.hide()
                cancellables = Set<AnyCancellable>()
            }
        })
    }
}
