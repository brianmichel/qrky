//
//  ReaderView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI

struct ReaderView: View {
    var model: ReaderViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(minWidth: 300,
                       maxWidth: 600,
                       minHeight: 300,
                       maxHeight: 600)
        }.border(borderColor(), width: 10)
    }

    func borderColor() -> Color {
        model.codes.count > 1 ? .green : .orange
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(model: ReaderViewModel())
    }
}
