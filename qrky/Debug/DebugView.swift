//
//  DebugView.swift
//  qrky
//
//  Created by Brian Michel on 6/23/21.
//

import SwiftUI
import CoreImage

struct DebugView: View {
    let reader = WindowReader()

    @State var windowSelection = Set<Window>()
    @State var capturedImage: NSImage?

    var body: some View {
        NavigationView {
            VStack {
                List(reader.windows, id: \.self, selection: $windowSelection) { window in
                    Text("\(window.ownerName)")
                }.listStyle(SidebarListStyle()).clipShape(RoundedRectangle(cornerRadius: 8.0, style: .circular)).padding()
                HStack {
                    Button("📸 Capture") {
                        captureSelectedWindow()
                    }
                }.padding([.bottom])
            }
            if capturedImage != nil {
                VStack {
                    Image(nsImage: capturedImage!).resizable().aspectRatio(contentMode: .fit)
                }
            } else {
                Text("No Image")
            }
        }
    }

    private func captureSelectedWindow() {
        guard let window = windowSelection.first else {
            return
        }

        let windowRect = NSRect(x: CGFloat(window.bounds.x),
                                y: CGFloat(window.bounds.y),
                                width: CGFloat(window.bounds.width),
                                height: CGFloat(window.bounds.height))

        let croppedImage = reader.screenshot(bounds: NSRectToCGRect(windowRect))

        capturedImage = croppedImage

        DispatchQueue.main.async {
            let codes = croppedImage?.ciImage()?.qrCodes()
            print("Code: \(String(describing: codes))")
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
