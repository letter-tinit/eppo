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
    var isAlertShowing = false
    var errorMessage = ""
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
            } receiveValue: { ownerOrderResponse in
                self.ownerOrders.removeAll()
                self.ownerOrders = ownerOrderResponse.data
            }
            .store(in: &cancellables)
    }
    
    func confirmed(orderId: Int) {
        isLoading = true
        
        APIManager.shared.updateOrderStatus(orderId: orderId, newStatus: 2)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.isAlertShowing = true
                }
            } receiveValue: { response in
                if (200..<299).contains(response.statusCode) {
                    self.errorMessage = "Đã xác nhận thành công"
                    self.isAlertShowing = true
                    self.updateData()
                } else {
                    self.errorMessage = "Quá trình xác nhận xảy ra lỗi"
                    self.isAlertShowing = true
                }
            }
            .store(in: &cancellables)
    }
    
    func finishPrepare(orderId: Int) {
        isLoading = true
        APIManager.shared.preparedOrder(orderId: orderId)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.errorMessage = "Đã cập nhật trạng thái thành công"
                    self.isAlertShowing = true
                    print("Đã cập nhật trạng thái thành công")
                    self.updateData()
                case .failure(let error):
                    self.errorMessage = "Lỗi không xác định: \(error)"
                    print("Unexpected error: \(error)")
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func updateData() {
//        DispatchQueue.main.asyncAfter(deadline:.now() + 0) { [weak self] in
        DispatchQueue.main.async { [weak self] in
            self?.getOwnerOrders()
        }
    }
    
    deinit {
        self.cancellables.forEach {$0.cancel()}
    }
}
