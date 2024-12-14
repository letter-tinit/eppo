//
//  BuyOrderViewModel.swift
//  Eppo
//
//  Created by Letter on 15/11/2024.
//

import Foundation
import Alamofire
import Combine
import Observation

enum BuyOrderAlert {
    case error, remind
}

@Observable
class BuyOrderViewModel {
    var selectedOrderState: OrderState = .waitingForConfirm
    
    var orders: [BuyHistoryOrder] = []
    var cancellables: Set<AnyCancellable> = []
    var isLoading = false
    var isAlertShowing: Bool = false
    var activeAlert: BuyOrderAlert = .remind
    var errorMessage: String?

    func getBuyOrderHistory() {
        self.isLoading = true
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
        }
        
        APIManager.shared.getBuyOrderHistory(pageIndex: 1, pageSize: 999, status: orderState)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.orders = []
                }
            } receiveValue: { buyHistoryResponse in
                print(buyHistoryResponse)
                self.orders = buyHistoryResponse.data
            }
            .store(in: &cancellables)
    }
    
    func receiveOrder(orderId: Int, newStatus: Int) {
        isLoading = true
        
        APIManager.shared.updateOrderStatus(orderId: orderId, newStatus: newStatus)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.activeAlert = .error
                    self.isAlertShowing = true
                }
            } receiveValue: { response in
                if (200..<299).contains(response.statusCode) {
                    self.getBuyOrderHistory()
                    self.errorMessage = "Cảm ơn bạn đã phản hồi"
                    self.activeAlert = .error
                    self.isAlertShowing = true
                } else {
                    self.errorMessage = "Phản hồi thất bại: \(response.message)"
                    self.activeAlert = .error
                    self.isAlertShowing = true
                }
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
                    self.getBuyOrderHistory()
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
