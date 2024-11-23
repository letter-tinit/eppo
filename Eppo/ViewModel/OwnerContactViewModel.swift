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
    
    var isLoading: Bool = false
    var isSigned: Bool = false
    var contractUrl: String?

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
                self?.contractUrl = ownerContractResponse.pdfUrl
            }
            .store(in: &cancellables)
    }
}
