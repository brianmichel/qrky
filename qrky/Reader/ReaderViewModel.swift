//
//  ReaderViewModel.swift
//  qrky
//
//  Created by Brian Michel on 6/24/21.
//

import Foundation
import AppKit
import UserNotifications
import SwiftUI
import Combine

final class ReaderViewModel: ObservableObject {
    @Published var codes: [String] = []

    func update(codes: [String]?) {
        guard let qrCodes = codes else {
            return
        }
        self.codes = qrCodes
    }
}

final class ReaderWindowModel {
    private enum Constants {
        static let readerDefaultSize = NSSize(width: 300, height: 300)
        static let notificationDebounceTime: RunLoop.SchedulerTimeType.Stride = 0.3
    }

    private let readerViewModel = ReaderViewModel()

    private let controller: NSWindowController
    private let reader = WindowReader()

    let foundCodeSubject = PassthroughSubject<String, Never>()

    private var storage = Set<AnyCancellable>()

    init() {
        let controller = ReaderWindowController(rootView: ReaderView(model: readerViewModel))
        controller.window?.title = "QR Reader"
        controller.window?.setContentSize(Constants.readerDefaultSize)

        self.controller = controller

        Publishers.MergeMany(
            [NSWindow.didMoveNotification,
             NSWindow.didResizeNotification,
             NSWindow.didBecomeKeyNotification
            ].map({ name in
                return NotificationCenter.default.publisher(for: name, object: controller.window)
            })
        )
        .debounce(for: Constants.notificationDebounceTime, scheduler: RunLoop.main)
        .sink { [weak self] notification in
            guard let window = notification.object as? NSWindow else {
                return
            }

            self?.checkForCode(in: window)
        }
        .store(in: &storage)
    }

    func show() {
        controller.window?.center()
        controller.showWindow(nil)
    }

    func hide() {
        controller.close()
    }

    private func checkForCode(in window: NSWindow) {
        reader.refreshWindows()

        DispatchQueue.main.async {
            guard let internalWindow = self.reader.windows.filter({ potentialWindow in
                potentialWindow.number == window.windowNumber
            }).first else {
                return
            }

            let windowRect = NSRect(x: CGFloat(internalWindow.bounds.x),
                                    y: CGFloat(internalWindow.bounds.y),
                                    width: CGFloat(internalWindow.bounds.width),
                                    height: CGFloat(internalWindow.bounds.height))

            let croppedImage = self.reader.screenshot(bounds: NSRectToCGRect(windowRect))

            let codes = croppedImage?.ciImage()?.qrCodes()

            print("Found codes: \(String(describing: codes))")

            self.readerViewModel.update(codes: codes)

            guard let first = codes?.first else {
                return
            }

            self.copyToPasteboard(value: first)
        }
    }

    func copyToPasteboard(value: String) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()

        pasteBoard.setString(value, forType: .string)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
            if let error = error {
                print("Got error: \(error)")
            } else if success {
                let content = UNMutableNotificationContent()
                content.title = "Copied QR Code"
                content.body = "Copied \"\(value)\" to clipboard from QR code."
                let request = UNNotificationRequest(identifier: "me.foureyes.bsm.qrky-copied-\(value)", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }

        foundCodeSubject.send(value)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
