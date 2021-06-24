//
//  ReaderViewModel.swift
//  qrky
//
//  Created by Brian Michel on 6/24/21.
//

import Foundation
import AppKit
import UserNotifications


final class ReaderViewModel: ObservableObject {
    @Published var codes: [String] = []
    @Published var foundCode: Bool = false
    

    func update(codes: [String]?) {
        guard let qrCodes = codes else {
            return
        }
        self.codes = qrCodes

        foundCode.toggle()
    }
}

final class ReaderWindowModel {
    private let readerViewModel = ReaderViewModel()

    private let controller: NSWindowController
    private let reader = WindowReader()

    init() {
        let controller = ReaderWindowController(rootView: ReaderView(model: readerViewModel))
        controller.window?.title = "QR Reader"
        controller.window?.setContentSize(NSSize(width: 300, height: 300))

        self.controller = controller

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowDidUpdate(notification:)),
                                               name: NSWindow.didMoveNotification,
                                               object: controller.window)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowDidUpdate(notification:)),
                                               name: NSWindow.didResizeNotification,
                                               object: controller.window)
    }

    func show() {
        controller.window?.center()
        controller.showWindow(nil)
    }

    func hide() {
        controller.close()
    }

    @objc func windowDidUpdate(notification: Notification) {
        reader.refreshWindows()

        guard let window = controller.window,
              notification.object as? NSWindow == window else {
            return
        }

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
                let request = UNNotificationRequest(identifier: "me.foureyes.bsm.qrky-copied-\(UUID().uuidString)", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
