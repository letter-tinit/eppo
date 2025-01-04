////
////  SamplePDFView.swift
////  Eppo
////
////  Created by Treasure Letter on 04/01/2025.
////
//
//import SwiftUI
//import PDFKit
//
//struct SamplePDFView: View {
//    @State private var pdfDocument: PDFDocument?
//    @State private var currentPage = 1
//    @State private var totalPages = 1
//    @State private var isLoading = false
//    @State private var scale: CGFloat = 1.0
//    let pdfURL = URL(string: "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf")!
//    
//    var body: some View {
//        ZStack {
//            if let document = pdfDocument {
//                PDFViewer(document: document, currentPage: $currentPage, totalPages: $totalPages)
//                    .edgesIgnoringSafeArea(.all)
//                    .scaleEffect(scale)
//                    .gesture(MagnificationGesture()
//                        .onChanged { value in
//                            self.scale = value.magnitude
//                        }
//                    )
//                
//                VStack {
//                    Spacer()
//                    HStack {
//                        Button(action: previousPage) {
//                            Image(systemName: "arrow.left")
//                        }
//                        .disabled(currentPage == 1)
//                        
//                        Text("\(currentPage) / \(totalPages)")
//                        
//                        Button(action: nextPage) {
//                            Image(systemName: "arrow.right")
//                        }
//                        .disabled(currentPage == totalPages)
//                        
//                        Spacer()
//                        
//                        Button(action: zoomIn) {
//                            Image(systemName: "plus.magnifyingglass")
//                        }
//                        
//                        Button(action: zoomOut) {
//                            Image(systemName: "minus.magnifyingglass")
//                        }
//                    }
//                    .padding()
//                    .background(Color.black.opacity(0.6))
//                    .foregroundColor(.white)
//                }
//            } else {
//                Text("PDF not loaded")
//            }
//            
//            if isLoading {
//                ProgressView()
//            }
//        }
//        .onAppear(perform: loadPDF)
//    }
//    
//    private func loadPDF() {
//        isLoading = true
//        URLSession.shared.dataTask(with: pdfURL) { data, response, error in
//            if let data = data {
//                DispatchQueue.main.async {
//                    self.pdfDocument = PDFDocument(data: data)
//                    self.totalPages = self.pdfDocument?.pageCount ?? 0
//                    self.isLoading = false
//                }
//            } else {
//                print("Failed to load PDF: \(error?.localizedDescription ?? "Unknown error")")
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                }
//            }
//        }.resume()
//    }
//    
//    private func nextPage() {
//        if currentPage < totalPages {
//            currentPage += 1
//        }
//    }
//    
//    private func previousPage() {
//        if currentPage > 1 {
//            currentPage -= 1
//        }
//    }
//    
//    private func zoomIn() {
//        scale *= 1.2
//    }
//    
//    private func zoomOut() {
//        scale /= 1.2
//    }
//}
//
//#Preview {
//    SamplePDFView()
//}
