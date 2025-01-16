//
// Created by Treasure Letter ♥
// 
// https://github.com/letter-tinit
//

import SwiftUI

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
            CustomHeaderView(title:"Hợp đồng trả trước")

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
    
//    func createContract() {
//        loadingMessage = "Đang tạo hợp đồng"
//        guard let plant = self.plant,
//              let contractNumber = self.contractNumber
//        else {
//            self.loadingMessage = "Tạo hợp đồng thất bại"
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isContactLoading = false
//            }
//            return
//        }
//
//        let contractDetails = [
//            ContractDetail(plantId: plant.id, totalPrice: rentTotalPrice())
//        ]
//
//        let contractRequest = ContractRequest(
//            contractNumber: contractNumber,
//            description: "Cho thuê \(plant.name)",
//            creationContractDate: Date(),
//            endContractDate: Date(),
//            totalAmount: rentTotalAmount(),
//            contractDetails: contractDetails
//        )
//
//        APIManager.shared.createContract(createContractRequest: contractRequest)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.loadingMessage = "Tạo hợp đồng thất bại"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.isContactLoading = false
//                    }
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { contractResponse in
//                print(contractResponse)
//                self.contractId = contractResponse.contractId
//                self.loadingMessage = "Đã tạo hợp đồng thành công"
//                self.getContractById()
//            }
//            .store(in: &cancellables)
//    }
//
//    func getContractById() {
//        self.loadingMessage = "Đang tải hợp đồng"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.isContactLoading = false
//        }
//        guard let contractId = self.contractId else {
//            self.loadingMessage = "Tải hợp đồng thất bại"
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isContactLoading = false
//            }
//            return
//        }
//
//        APIManager.shared.getContractById(contractId: contractId)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.loadingMessage = "Tải hợp đồng thất bại"
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.isContactLoading = false
//                    }
//                }
//            } receiveValue: { contractResponse in
//                print(contractResponse)
//                self.contractUrl = contractResponse.data.contractUrl
//                self.loadingMessage = "Tải hợp đồng thành công"
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    self.isContactLoading = false
//                }
//            }
//            .store(in: &cancellables)
//
//    }
}

// MARK: - PREVIEW
#Preview {
    ViewContractScreen(url: "https://www.antennahouse.com/hubfs/xsl-fo-sample/pdf/basic-link-1.pdf")
}
