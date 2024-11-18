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
    var selectedOrderState: OrderState = .waitingForConfirm
    
    var orders: [HireHistoryOrder] = []
    var cancellables: Set<AnyCancellable> = []
    
    func getHireOrderHistory() {
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
        
        APIManager.shared.getHireOrderHistory(pageIndex: 1, pageSize: 999, status: orderState)
            .sink { completion in
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
        APIManager.shared.cancelOrder(id: id)
            .sink { completion in
                switch completion {
                case .finished:
                    self.getHireOrderHistory()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
