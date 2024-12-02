//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import WebKit

struct ContractScreen: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ItemDetailsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var loadingState: PDFWebView.LoadingState = .loading
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomHeaderView(title: "Hợp đồng cho thuê")
                
                //            if let url = URL(string: viewModel.contractUrl ?? "") {
                //                PDFWebView(url: url)
                //                    .edgesIgnoringSafeArea(.all) // Để webview chiếm toàn màn hình nếu cần
                //                    .frame(maxWidth: .infinity)
                //                    .frame(height: 500)
                //            }
                if let urlString = viewModel.contractUrl, let url = URL(string: urlString) {
                    PDFWebView(url: url, loadingState: $loadingState)
                        .frame(height: 500)
                        .edgesIgnoringSafeArea(.all)
                }
                
                Spacer()
                
                HStack {
                    Text(verbatim: "Bằng việc bấm vào nút \"Chấp nhận điều khoản\", bạn đã đồng ý với các điều khoản trong hợp đồng ở trên")
                        .font(.headline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.isSigned)
                        .labelsHidden()
                }
                .padding()
                
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 60)
                            .foregroundStyle(viewModel.isSigned ? .red : .gray)
                        
                        Text("Chấp nhận điều khoản")
                            .foregroundStyle(.black)
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                } // LOGIN BUTTON
                .padding()
                .padding(.bottom, 80)
                .disabled(!viewModel.isSigned)
            }
            .ignoresSafeArea(.container, edges: .vertical)
            .disabled(viewModel.isContactLoading)
            
            CustomLoadingCenterView(title: viewModel.loadingMessage)
                .opacity(viewModel.isContactLoading ? 1 : 0)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.createOrderRental()
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .cancel({
                self.dismiss()
            }))
        }
    }
}

// Tạo một wrapper cho WKWebView
//struct PDFWebView: UIViewRepresentable {
//    let url: URL
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        uiView.load(request)
//    }
//}


// MARK: - PREVIEW
#Preview {
    ContractScreen(viewModel: ItemDetailsViewModel())
}
