//
// Created by Treasure Letter ♥
// 
// https://github.com/letter-tinit
//

import SwiftUI
import Combine
import Observation

struct ViewContractScreen: View {
    // MARK: - PROPERTY
    let url: String
    @State private var loadingState: PDFWebView.LoadingState = .loading
    @State private var isShowingPDFView: Bool = false
    @State private var isLoadingFaild: Bool = false

    init(url: String) {
        self.url = url
    }

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title:"Hợp đồng thuê")

            ZStack {
                LoadingCenterView()
                
                if let pdfUrl = URL(string: url) {
                    PDFWebView(url: pdfUrl,loadingState : $loadingState)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(isShowingPDFView ? 1 : 0)
                } else if isLoadingFaild {
                    CenterView {
                        Text("Tải PDF thất bại")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                } else {
                    LoadingCenterView()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .onChange(of: loadingState) { oldValue, newValue in
            switch newValue {
            case .loading:
                isShowingPDFView = false
            case .success:
                isShowingPDFView = true
            case .failed:
                isShowingPDFView = false
                isLoadingFaild = true
            }
        }
    }
}

struct ViewPreReturnContractScreen: View {
    // MARK: - PROPERTY
    @State var viewModel: ViewPreReturnContractViewModel
    
    init(viewModel: ViewPreReturnContractViewModel) {
        self.viewModel = viewModel
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    @State private var loadingState: PDFWebView.LoadingState = .loading
    @State private var isShowingPDFView: Bool = false

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title:"Hợp đồng trả trước")
            
            ZStack {
                LoadingCenterView()
                
                if let pdfUrl = URL(string: viewModel.url) {
                    PDFWebView(url: pdfUrl,loadingState : $loadingState)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(isShowingPDFView ? 1 : 0)
                } else if viewModel.isLoadingFaild {
                    CenterView {
                        Text("Tải PDF thất bại")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                } else {
                    LoadingCenterView()
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getContract()
        }
        .onChange(of: loadingState) { oldValue, newValue in
            switch newValue {
            case .loading:
                isShowingPDFView = false
            case .success:
                isShowingPDFView = true
            case .failed:
                isShowingPDFView = false
                viewModel.isLoadingFaild = true
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ViewContractScreen(url: "https://www.antennahouse.com/hubfs/xsl-fo-sample/pdf/basic-link-1.pdf")
}


@Observable
class ViewPreReturnContractViewModel {
    let orderId: Int
    let code: String
    var url: String = ""
    var isLoadingFaild: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    init(orderId: Int, code: String) {
        self.orderId = orderId
        self.code = code
    }
    
    func getContract() {
        APIManager.shared.getEarlyReturnContract(orderId: orderId, code: code)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.isLoadingFaild = true
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let url = response.data?.contractUrl {
                    self.url = url
                } else {
                    self.isLoadingFaild = true
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
}
