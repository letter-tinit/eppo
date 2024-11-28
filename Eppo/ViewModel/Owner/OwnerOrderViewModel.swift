//
//  OwnerOrderViewModel.swift
//  Eppo
//
//  Created by Letter on 28/11/2024.
//

import Foundation
import Combine
import Observation

@Observable
class OwnerOrderViewModel {
    var isStatusPickerPopup: Bool = false
    var isLoading = false
    var cancellables: Set<AnyCancellable> = []
    var ownerOrders: [OwnerOrder] = []
    
    func getOwnerOrders() {
        isLoading = true
        APIManager.shared.getOwnerOrders(pageIndex: 1, pageSize: 999)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] ownerOrderResponse in
                self?.ownerOrders = ownerOrderResponse.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        self.cancellables.forEach {$0.cancel()}
    }
}
