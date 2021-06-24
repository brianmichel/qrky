//
//  ReaderView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct ReaderView: View {
    @ObservedObject var model: ReaderViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(minWidth: 300,
                       maxWidth: 600,
                       minHeight: 300,
                       maxHeight: 600)
                .border(borderColor(), width: 10)
                .animation(.easeInOut(duration: 0.1))
        }
    }

    func borderColor() -> Color {
        model.codes.count > 0 ? .green : .red
    }
}

struct ReaderView_Previews: PreviewProvider {
    static let model = ReaderViewModel()

    static var previews: some View {
        ReaderView(model: model)
    }
}
