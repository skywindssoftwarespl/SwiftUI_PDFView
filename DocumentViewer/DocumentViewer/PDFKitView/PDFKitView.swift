//
//  PDFKitView.swift
//  DocumentViewer
//
//  Created by Vishal on 09/09/21.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    @State var pdfView: PDFView = PDFView()
    @State var drawingTool: DrawingTool = .cancel
    
    var url: URL
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileUrl = URL(fileURLWithPath: "backup2", relativeTo: directoryUrl).appendingPathExtension("pdf")
                    
                    pdfView.document?.write(to: fileUrl)
                }, label: {
                    Text("Save")
                })
                
                Picker("Edit", selection: $drawingTool) {
                    ForEach(DrawingTool.allCases, id: \.self) { tool in
                        HStack {
                            Text(tool.rawValue)
                            tool.image
                        }
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Button(action: {
                    pdfView.goToPreviousPage(nil)
                }, label: {
                    Image(systemName: "arrowtriangle.left.fill")
                })
                Button(action: {
                    pdfView.goToNextPage(nil)
                }, label: {
                    Image(systemName: "arrowtriangle.right.fill")
                })
                Button(action: {
                    pdfView.zoomIn(nil)
                }, label: {
                    Image(systemName: "plus.magnifyingglass")
                })
                Button(action: {
                    pdfView.zoomOut(nil)
                }, label: {
                    Image(systemName: "minus.magnifyingglass")
                })
            }
            .padding(8)
            .background(Color.black.opacity(0.1))
            
            PDFKitRepresentedView(url, pdfView: $pdfView, drawingTool: $drawingTool)
        }
        .foregroundColor(.black)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    @Binding var pdfView: PDFView
    @Binding var drawingTool: DrawingTool
    
    let url: URL
    
    let pdfDrawingGestureRecognizer = DrawingGestureRecognizer()
    let pdfDrawer = PDFDrawer()
    
    init(_ url: URL, pdfView: Binding<PDFView>, drawingTool: Binding<DrawingTool>) {
        self.url = url
        _pdfView = pdfView
        _drawingTool = drawingTool
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.displayMode = .singlePageContinuous
        
        pdfView.addGestureRecognizer(pdfDrawingGestureRecognizer)
        pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawer
        pdfDrawer.pdfView = pdfView
        
        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
        if drawingTool == .cancel {
            pdfDrawingGestureRecognizer.changeEditing(false)
        } else {
            pdfDrawingGestureRecognizer.changeEditing(true)
        }
        pdfDrawer.drawingTool = drawingTool
    }
}

//struct PDFKitView_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFKitView()
//    }
//}
