//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct HomeView: View {
    @AppStorage(PreferenceKeys.autoOpenScanner) private var autoOpenScanner = false

    private enum Constants {
        static let minWidth: CGFloat = 400
        static let maxWidth: CGFloat = 600
        static let minHeight: CGFloat = 300
        static let maxHeight: CGFloat = 700
    }
    @ObservedObject var model: HomeViewModel

    var body: some View {
        VStack {
            if model.decodedItems.count > 0 {
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(model.decodedItems, id: \.self) { item in
                            DecodedItemCell(date: item.date, value: item.value) {
                                model.copyToClipboard(item: item)
                            }
                        }.animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                    }
                }
            } else {
                EmptyHomeView()
            }
        }.toolbar(content: {
            Button(action: {
                model.showReader()
            }, label: {
                Label("New Scanner", systemImage: "viewfinder")
            })
            .keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
            .help("Show the QR code scanner.")
        }).frame(minWidth: Constants.minWidth,
                 maxWidth: Constants.maxWidth,
                 minHeight: Constants.minHeight,
                 maxHeight: Constants.maxHeight,
                 alignment: .center)
        .background(
            // TODO: This is a hack to bridge into AppKit and disable the full screen button.
            HostingWindowFinder { window in
                window?.disableFullScreen()
            }
        ).onAppear(perform: {
            if autoOpenScanner {
                model.showReader()
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(model: HomeViewModel())
    }
}
