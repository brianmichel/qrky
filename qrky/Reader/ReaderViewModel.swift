//
//  ReaderViewModel.swift
//  qrky
//
//  Created by Brian Michel on 6/24/21.
//

import Foundation
import AppKit
import UserNotifications
import Combine


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

    private var storage = Set<AnyCancellable>()

    init() {
        let controller = ReaderWindowController(rootView: ReaderView(model: readerViewModel))
        controller.window?.title = "QR Reader"
        controller.window?.setContentSize(NSSize(width: 300, height: 300))

        self.controller = controller

//        [NSWindow.didMoveNotification,
//         NSWindow.didBecomeKeyNotification,
//         NSWindow.didResizeNotification,
//         NSWindow.didResignKeyNotification,
//        ].forEach { name in
//            NotificationCenter.default.addObserver(self,
//                                                   selector: #selector(windowDidUpdate(notification:)),
//                                                   name: name,
//                                                   object: controller.window)
//        }

        Publishers.MergeMany(
            NotificationCenter.default.publisher(for: NSWindow.didMoveNotification, object: controller.window),
            NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification, object: controller.window),
            NotificationCenter.default.publisher(for: NSWindow.didResizeNotification, object: controller.window),
            NotificationCenter.default.publisher(for: NSWindow.didResignKeyNotification, object: controller.window)
        )
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .sink { [weak self] publisher in
            guard let window = publisher.object as? NSWindow else {
                return
            }

            self?.windowDidUpdate(window: window)
        }.store(in: &storage)
    }

    func show() {
        controller.window?.center()
        controller.showWindow(nil)
    }

    func hide() {
        controller.close()
    }

    func windowDidUpdate(window: NSWindow) {
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
                let request = UNNotificationRequest(identifier: "me.foureyes.bsm.qrky-copied-\(value)", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
