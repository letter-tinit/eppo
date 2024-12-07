//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ReviewOwnerContractScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel: OwnerContactViewModel = OwnerContactViewModel()
    @State private var loadingState: PDFWebView.LoadingState = .loading

    // MARK: - BODY

    var body: some View {
        VStack {
            CustomHeaderView(title: "Hợp đồng của tôi")
            
            if let urlString = viewModel.contractUrl, let url = URL(string: urlString) {
                PDFWebView(url: url, loadingState: $loadingState)
                    .edgesIgnoringSafeArea(.all)
            } else if viewModel.isLoading {
                CenterView {
                    Text("Đang tải hợp đồng")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
            } else {
                CenterView {
                    Text("Lỗi khi tải hợp đồng")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.createOwnerContract()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ReviewOwnerContractScreen()
}
