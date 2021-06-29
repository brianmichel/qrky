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
    @AppStorage(PreferenceKeys.autoCopyQRCode) private var autoCopyQRCode = false

    @Published var codes: [String] = []
    @Published var showCopySheet = false

    let foundCodeSubject: PassthroughSubject<String, Never>

    init(foundCodeSubject: PassthroughSubject<String, Never>) {
        self.foundCodeSubject = foundCodeSubject
    }

    func update(codes: [String]?) {
        self.codes = codes ?? []

        if !autoCopyQRCode {
            showCopySheet = self.codes.count > 0
        } else if let first = self.codes.first {
            foundCodeSubject.send(first)
        }
    }

    func manuallyCopy(item: String) {
        foundCodeSubject.send(item)

        // Clear out the old codes since we just took action
        // and we should wait for some user input before retriggering
        clearCodes()
    }

    func clearCodes() {
        update(codes: nil)
    }
}

final class ReaderWindowModel {
    private enum Constants {
        static let readerDefaultSize = NSSize(width: 300, height: 300)
        static let notificationDebounceTime: RunLoop.SchedulerTimeType.Stride = 0.3
    }

    private let readerViewModel: ReaderViewModel

    private let controller: NSWindowController
    private let reader = WindowReader()

    let foundCodeSubject = PassthroughSubject<String, Never>()

    private var storage = Set<AnyCancellable>()

    init() {
        readerViewModel = ReaderViewModel(foundCodeSubject: foundCodeSubject)
        let controller = ReaderWindowController(rootView: ReaderView(model: readerViewModel))
        controller.window?.title = "QR Reader"
        controller.window?.setContentSize(Constants.readerDefaultSize)

        self.controller = controller

        Publishers.MergeMany(
            [NSWindow.didMoveNotification,
             NSWindow.didResizeNotification,
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
        }
    }
}
