//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var model = HomeViewModel()

    private var gridLayout = [
        GridItem(.fixed(200))
    ]

    var body: some View {
        VStack {
            if model.decodedItems.count > 0 {
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(model.decodedItems, id: \.self) { item in
                            DecodedItemCell(date: item.date, value: item.value)
                                .frame(minWidth: 200)
                        }
                    }
                }.frame(minWidth: 400, minHeight: 300)
            } else {
                VStack(spacing: 20) {
                    Text("No Codes Found").font(.largeTitle)
                    Text("Scan a QR code and it will show up here until you quit the application.")
                }.padding()
            }
        }.toolbar(content: {
            Button(action: {
                model.showReader()
            }, label: {
                Label("New Scanner", systemImage: "qrcode.viewfinder")
            })
            .keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
        }).frame(minWidth: 400,
                 maxWidth: 600,
                 minHeight: 300,
                 maxHeight: 700,
                 alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
