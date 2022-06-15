//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @AppStorage(PreferenceKeys.autoOpenScanner) private var autoOpenScanner = false

    private enum Constants {
        static let minWidth: CGFloat = 400
        static let maxWidth: CGFloat = 600
        static let minHeight: CGFloat = 300
        static let maxHeight: CGFloat = 700
    }

    var store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.items.count > 0 {
                    ScrollView {
                        LazyVStack(spacing: 5) {
                            ForEach(viewStore.items, id: \.self) { item in
                                DecodedItemCell(date: item.date, value: item.value) {
                                    viewStore.send(.copyToClipboard(item))
                                }
                            }.animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                        }
                    }
                } else {
                    EmptyHomeView()
                }
            }.toolbar(content: {
                Button(action: {
                    viewStore.send(.beginScanning)
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
                    viewStore.send(.beginScanning)
                }
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView(store: .init(initialState: .init(),
                                  reducer: appReducer,
                                  environment: .live))
        }
    }
}
