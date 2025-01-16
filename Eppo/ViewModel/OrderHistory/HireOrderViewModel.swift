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

enum HireOrderViewModelActiveAlert {
    case remind
    case finish
    case error
}

@Observable
class HireOrderViewModel {
    var selectedOrderState: HireOrderState = .waitingForConfirm
    
    var orders: [HireHistoryOrder] = []
    var cancellables: Set<AnyCancellable> = []
    var isLoading = false
    var isAlertShowing: Bool = false
    var activeAlert: BuyOrderAlert = .remind
    var errorMessage: String?
    var preReturnResponseData: PreReturnDetail?
    var deposit: Double = 0.0

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
                    self.getHireOrderHistory()
                    self.errorMessage = "Cảm ơn bạn đã phản hồi"
                    self.activeAlert = .error
                    self.isAlertShowing = true
                } else {
                    self.errorMessage = "Phản hồi thất bại"
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
    
    // MARK: - RATAKE
    
    func requestData(orderId: Int, plantId: Int) {
        isLoading = true
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIManager.shared.getPreReturnDetails(orderId: orderId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            } receiveValue: { [weak self] response in
                self?.preReturnResponseData = response.data
            }
            .store(in: &self.cancellables)
        
        dispatchGroup.enter()
        APIManager.shared.getDeposit(plantId: plantId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
            } receiveValue: { [weak self] response in
                if let deposit = response.data {
                    self?.deposit = deposit
                }
            }
            .store(in: &self.cancellables)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func getPreReturnDetails(orderId: Int) {
        isLoading = true
        
        APIManager.shared.getPreReturnDetails(orderId: orderId)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.preReturnResponseData = response.data
            }
            .store(in: &cancellables)
    }
    
    func getDepositByPlantId(plantId: Int) {
        APIManager.shared.getDeposit(plantId: plantId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                if let deposit = response.data {
                    self?.deposit = deposit
                }
            }
            .store(in: &cancellables)
    }
    
    func confirmPreReturn(orderId: Int) {
        isLoading = true
        
        APIManager.shared.confirmRefund(orderId: orderId)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showAlert(.error, message: error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                preReturnResponseData?.order.orderDetails[0].isReturnSoon = (200..<299).contains(response.statusCode)
                showAlert(.error, message: response.message)
            }
            .store(in: &cancellables)
    }
    
    func showAlert(_ activeAlert: BuyOrderAlert, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isAlertShowing.toggle()
            self.activeAlert = activeAlert
            self.errorMessage = message
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
