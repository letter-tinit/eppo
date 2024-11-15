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

@Observable
class BuyOrderViewModel {
    var selectedOrderState: OrderState = .waitingForConfirm
    
    var orders: [BuyHistoryOrder] = []
    var cancellables: Set<AnyCancellable> = []
    
    func getBuyOrderHistory() {
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
    
    deinit {
        cancellables.removeAll()
    }
}
