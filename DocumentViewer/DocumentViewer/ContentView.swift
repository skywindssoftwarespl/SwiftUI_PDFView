//
//  ContentView.swift
//  DocumentViewer
//
//  Created by Vishal on 09/09/21.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    let fileUrl = Bundle.main.url(forResource: "sample", withExtension: "pdf")!

    var body: some View {
        VStack {
            HStack {
                Text("Document Viewer")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            PDFKitView(url: fileUrl)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
