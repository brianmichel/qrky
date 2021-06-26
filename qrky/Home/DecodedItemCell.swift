//
//  DecodedItemCell.swift
//  QRky
//
//  Created by Brian Michel on 6/26/21.
//

import SwiftUI

struct DecodedItemCell: View {
    @State var mouseHover = false

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
            VStack(spacing: 10) {
                HStack {
                    Text(value).font(.largeTitle)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(formatter.string(from: date)).font(.callout)
                }
            }.padding().background(RoundedRectangle(cornerRadius: 20, style: .continuous).foregroundColor(.orange))
            if mouseHover {
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Label("Copy to clipboard", systemImage: "doc.on.doc.fill")
                    })
                }
            }
        }
        .padding()
        .onHover(perform: { hovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                mouseHover = hovering
            }
        })
    }
}

struct DecodedItemCell_Previews: PreviewProvider {
    static var previews: some View {
        DecodedItemCell(date: Date(), value: "https://cool.app/rad").padding()
    }
}
