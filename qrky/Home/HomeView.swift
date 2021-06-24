//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.openURL) var openURL

    let model = HomeViewModel()
    let reader = WindowReader()

    var body: some View {
        VStack {
            HStack {
                Button("Open Reader") {
                    let reader = ReaderWindow.windowController()
                    reader.window?.title = "Reader"
                    reader.window?.setContentSize(NSSize(width: 400, height: 500))
                    reader.showWindow(self)
                }

                Button("Open Debugger") {
                    let controller = DebugView().inWindowController()
                    controller.window?.title = "Debug Menu"
                    controller.window?.setContentSize(NSSize(width: 600, height: 400))
                    controller.showWindow(self)
                }
            }

        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
