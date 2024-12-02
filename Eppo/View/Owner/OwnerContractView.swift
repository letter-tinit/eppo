//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI
import WebKit

struct OwnerContractView: View {
    // MARK: - PROPERTY
    @State var viewModel: OwnerContactViewModel = OwnerContactViewModel()
    @AppStorage("isSigned") var isSigned: Bool = false
    @State private var loadingState: PDFWebView.LoadingState = .loading

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            Header()
            
            if let urlString = viewModel.contractUrl, let url = URL(string: urlString) {
                PDFWebView(url: url, loadingState: $loadingState)
                    .frame(height: 500)
                    .edgesIgnoringSafeArea(.all)
            }
            
            Spacer()
            
            Toggle("Tôi đồng ý với các điều khoản trong hợp đồng", isOn: $viewModel.isSigned)
                .padding(.horizontal, 10)
                .font(.caption)
                .padding(.vertical, 10)
            
            Button {
                viewModel.signContract()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 60)
                        .foregroundStyle(viewModel.isSigned ? .red : .gray)
                    
                    Text("Chấp nhận hợp đồng")
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .bold))
                }
                
            } // LOGIN BUTTON
            .padding()
            .disabled(!viewModel.isSigned)
            .padding(.bottom, 80)
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            viewModel.createOwnerContract()
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .default(Text("Xác nhận"), action: {
                self.isSigned = viewModel.isSucessSigned
            }))
        }
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerContractView()
}

struct Header: View {
    @AppStorage("isLogged") var isLogged: Bool = false
    
    var body: some View {
        HStack {
            Button {
                isLogged = false
            } label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, alignment: .leading)
            }
            
            Spacer()
            
            Text("Hợp đồng người bán")
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
                .padding(.leading, -30)
                .padding(.bottom, 6)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 90, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}
