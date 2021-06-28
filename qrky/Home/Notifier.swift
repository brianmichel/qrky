//
//  Notifier.swift
//  QRky
//
//  Created by Brian Michel on 6/28/21.
//

import Foundation
import UserNotifications
import OrderedCollections
import SwiftUI
import Combine

final class Notifier {
    @AppStorage(PreferenceKeys.notificationState) private var notificationState = NotificationsState.on

    private var storage = Set<AnyCancellable>()

    func notify(for code: DecodedItem, storage: OrderedSet<DecodedItem>) {
        shouldNotify(for: code, notificationState: notificationState, storage: storage)
            .compactMap { value in
                return value
            }
            .sink { item in
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                    if let error = error {
                        print("Got error: \(error)")
                    } else if success {
                        let content = UNMutableNotificationContent()
                        content.title = "Copied QR Code"
                        content.body = "Copied \"\(item.value)\" to clipboard from QR code."
                        let request = UNNotificationRequest(identifier: "me.foureyes.bsm.qrky-copied-\(item.value)", content: content, trigger: nil)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    }
                }
            }.store(in: &self.storage)
    }

    private func shouldNotify(for code: DecodedItem, notificationState: NotificationsState, storage: OrderedSet<DecodedItem>) -> AnyPublisher<DecodedItem?, Never> {
        switch notificationState {
        case .off:
            return Just(nil).eraseToAnyPublisher()
        case .on:
            let alreadyExists = storage.contains(code)
            if alreadyExists {
                return Just(nil).eraseToAnyPublisher()
            } else {
                return Just(code).eraseToAnyPublisher()
            }
        case .onWithDuplicates:
            return Just(code).eraseToAnyPublisher()
        }
    }
}
