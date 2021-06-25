//
//  HomeView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct DecodedItemCell: View {
    let date: Date
    let value: String

    // TODO: Probably too slow doing this on the fly, might be useful to come out of the VM.
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    var body: some View {
        VStack(spacing: 10) {
            Text(value).font(.title)
            HStack {
                Spacer()
                Text(formatter.string(from: date)).font(.footnote)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).foregroundColor(.orange))
    }
}

struct HomeView: View {
    @ObservedObject var model = HomeViewModel()

    private var gridLayout = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        VStack {
            if model.decodedItems.count > 0 {
                ScrollView {
                    LazyVGrid(columns: gridLayout) {
                        ForEach(model.decodedItems, id: \.self) { item in
                            DecodedItemCell(date: item.date, value: item.value)
                                .frame(minWidth: 200)
                        }
                    }
                }.frame(minWidth: 400, minHeight: 300).padding([.bottom, .horizontal])
            } else {
                VStack {
                    Text("No Codes Found").font(.largeTitle)
                    Text("Scan a QR code and it will show up here until you quit the application.")
                }.padding()
            }
            Button("Scan") {
                model.showReader()
            }.padding(.bottom)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
