//
//  OwnerHomeViewModel.swift
//  Eppo
//
//  Created by Letter on 29/11/2024.
//

import Foundation
import Observation
import Combine

enum OwnerHomeActiveAlert: String {
    case remind = "Nhắc nhở"
    case error = "Có lỗi xảy ra"
    case succcess = "Thành công"
}

@Observable
class OwnerHomeViewModel {
    private var cancellables: Set<AnyCancellable> = []
    var plants: [Plant] = []
    var selectedType: TypeEcommerce = .buy
    var hasError = false
    var isLoading = false
    var message: String?
    var activeAlert: OwnerHomeActiveAlert = .error
    var isShowingAlert: Bool = false
    var onProcessPlant: Plant?
    
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
    
    func toggleRemind(plant: Plant) {
        onProcessPlant = plant
        showAlert(activeAlert: .remind, message: "Bạn có chắc muốn xoá cây không?")
    }
    
    func deletePlant() {
        guard let plantId = onProcessPlant?.id else {
            showAlert(activeAlert: .error, message: "Lỗi khi lấy dữ liệu của cây")
            return
        }
        
        isLoading = true
        APIManager.shared.deletePlant(plantId: plantId)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if case .custom(let message) = error {
                        self?.showAlert(activeAlert: .error, message: message )
                    } else {
                        self?.showAlert(activeAlert: .error, message: error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] message in
                self?.showAlert(activeAlert: .succcess, message: message)
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(activeAlert: OwnerHomeActiveAlert, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activeAlert = activeAlert
            self?.message = message
            self?.isShowingAlert = true
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
