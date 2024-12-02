//
//  OwnerContactViewModel.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

import Foundation
import Combine
import Observation

@Observable
class OwnerContactViewModel {
    var cancellables: Set<AnyCancellable> = []
    
    var isAlertShowing: Bool = false
    var message: String = "Nhắc nhở"
    var isLoading: Bool = false
    var isSigned: Bool = false
    var contractUrl: String?
    var contractId: Int = 0
    var isSucessSigned = false
    
    func createOwnerContract() {
        APIManager.shared.createOwnerContract()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] ownerContractResponse in
                if let contractUrl = ownerContractResponse.pdfUrl,
                   let contractId = ownerContractResponse.contractId {
                    self?.contractUrl = contractUrl
                    self?.contractId = contractId
                }
                
                if let existedContract = ownerContractResponse.existingContract {
                    self?.contractUrl = existedContract.contractUrl
                    self?.contractId = existedContract.contractId
                }
            }
            .store(in: &cancellables)
    }
    
    func signContract() {
        isLoading = true
        APIManager.shared.updateContract(contractId: contractId, status: 1)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.message = "Đã ký thành công"
                    self.isAlertShowing = true
                    self.isSucessSigned = true
                    break
                case .failure(let error):
                    print(error)
                    self.message = "Có lỗi xảy ra\n\(error.localizedDescription)"
                    self.isAlertShowing = true
                }
            } receiveValue: { _ in}
            .store(in: &cancellables)
    }
}
