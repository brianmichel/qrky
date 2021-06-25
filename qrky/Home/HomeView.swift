//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct HomeView: View {
    private let readerModel = ReaderWindowModel()

    let model = HomeViewModel()

    var body: some View {
        HSplitView {
            Text("hi")
            Button("Scan") {
                readerModel.show()
            }
            Button("Open Debugger") {
                let controller = DebugView().inWindowController()
                controller.window?.title = "Debug Menu"
                controller.window?.setContentSize(NSSize(width: 600, height: 400))
                controller.showWindow(self)
            }
        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
