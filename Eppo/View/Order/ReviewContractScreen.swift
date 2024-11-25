//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import WebKit

struct ReviewContractScreen: View {
    // MARK: - PROPERTY
    var contractUrl: String?
    @Binding var isSigned: Bool
    @Environment(\.dismiss) var dismiss
    @State private var loadingState: PDFWebView.LoadingState = .loading
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Hợp đồng cho thuê")
            if let urlString = contractUrl, let url = URL(string: urlString) {
                PDFWebView(url: url, loadingState: $loadingState)
                    .frame(height: 500)
                    .edgesIgnoringSafeArea(.all)
            }
            
            Spacer()
            
            Toggle("Tôi đồng ý với các điều khoản trong hợp đồng", isOn: $isSigned)
                .padding(.horizontal, 10)
                .font(.caption)
                .padding(.vertical, 10)
            
            Button {
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 60)
                        .foregroundStyle(isSigned ? .red : .gray)
                    
                    Text("Chấp nhận hợp đồng")
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .bold))
                }
                
            } // LOGIN BUTTON
            .padding()
            .padding(.bottom, 80)
            .disabled(!isSigned)
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .navigationBarBackButtonHidden()
    }
}
