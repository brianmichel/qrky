//
//  HomeViewModel.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import Foundation
import SwiftUI
import OrderedCollections
import Combine

final class HomeViewModel: ObservableObject {
    @Published var decodedItems = OrderedSet<DecodedItem>()

    private let readerModel = ReaderWindowModel()

    private var storage = Set<AnyCancellable>()

    init() {
        readerModel.foundCodeSubject.sink { [weak self] code in
            self?.decodedItems.append(DecodedItem(value: code))
        }.store(in: &storage)
    }

    func showReader() {
        readerModel.show()
    }

    func hideReader() {
        readerModel.hide()
    }
}
