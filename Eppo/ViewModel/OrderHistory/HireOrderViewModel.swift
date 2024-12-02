//
//  HireOrderViewModel.swift
//  Eppo
//
//  Created by Letter on 15/11/2024.
//

import Foundation
import Alamofire
import Combine
import Observation

@Observable
class HireOrderViewModel {
    var selectedOrderState: HireOrderState = .waitingForConfirm
    
    var orders: [HireHistoryOrder] = []
    var cancellables: Set<AnyCancellable> = []
    var isLoading = false
    var isAlertShowing: Bool = false
    var activeAlert: BuyOrderAlert = .remind
    var errorMessage: String?

    func getHireOrderHistory() {
        isLoading = true
        var orderState = 1
        
        switch selectedOrderState {
        case .waitingForConfirm:
            orderState = 1
        case .waitingForPackage:
            orderState = 2
        case .waitingForDeliver:
            orderState = 3
        case .delivered:
            orderState = 4
        case .canceled:
            orderState = 5
        case .refunded:
            orderState = 6
        }
        
        APIManager.shared.getHireOrderHistory(pageIndex: 1, pageSize: 999, status: orderState)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.orders = []
                }
            } receiveValue: { hireHistoryResponse in
                print(hireHistoryResponse)
                self.orders = hireHistoryResponse.data
            }
            .store(in: &cancellables)
    }
    
    func cancelOrder(id: Int) {
        isLoading = true
        
        APIManager.shared.cancelOrder(id: id)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.getHireOrderHistory()
                    self.errorMessage = "Đơn hàng đã huỷ thành công"
                    self.activeAlert = .error
                    self.isAlertShowing = true
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.activeAlert = .error
                    self.isAlertShowing = true
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
