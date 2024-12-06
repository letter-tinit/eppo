//
//  OwnerHomeViewModel.swift
//  Eppo
//
//  Created by Letter on 29/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class OwnerHomeViewModel {
    private var cancellables: Set<AnyCancellable> = []
    var plants: [Plant] = []
    var selectedType: TypeEcommerce = .buy
    var hasError = false
    var isLoading = false
    
    func getOwnerPlant() {
        isLoading = true
        hasError = false
        var typeEcommerceId = 1
        
        switch selectedType {
        case .buy:
            typeEcommerceId = 1
        case .hire:
            typeEcommerceId = 2
        case .auction:
            typeEcommerceId = 3
        }
        
        APIManager.shared.getAcceptPlant(pageIndex: 1, pageSize: 9999, typeEcommerceId: typeEcommerceId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.plants.removeAll()
                    print(error.localizedDescription)
                    self?.hasError = true
                }
            } receiveValue: {[weak self] response in
                self?.plants = response.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
