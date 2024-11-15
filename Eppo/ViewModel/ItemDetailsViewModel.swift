//
//  ItemDetailsViewModel.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation
import Combine
import Observation

enum ActiveAlert {
    case first, second
}

@Observable class ItemDetailsViewModel {
    var plant: Plant?
    var isAlertShowing: Bool = false
    var message: String = ""
    var isLoading: Bool = false
    
    // MARK: - HireItemDetailScreen
    var selectedDate = Date()
    var numberOfMonth = 1
    let step = 1
    let range = 1...99
    var deliveriteFree: Double?
    var contractNumber: Int?
    var contractId: Int?
    var contractUrl: String?
    var isSigned: Bool = false
    var isLinkActive = false
    
    // MARK: - BuyItemDetailScreen
    var selectedPaymentMethod: PaymentMethod = .cashOnDelivery

    private var cancellables = Set<AnyCancellable>()
    
    func getPlantById(id: Int) {
        self.isLoading = true
        
        APIManager.shared.getPlantById(id: id)
            .sink { result in
                switch result {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { plantResponse in
                self.plant = plantResponse.data
            }
            .store(in: &cancellables)
    }
    
    // MARK: - HireItemDetailScreen
    
    func createOrderRental() {
        self.deliveriteFree = 0
        guard let plant = self.plant,
        let deliveriteFree = self.deliveriteFree else {
            return
        }
        
        let order = Order(
            totalPrice: rentTotalPrice(),
            deliveryFee: deliveriteFree,
            deliveryAddress: "Thành Phố Hồ Chí Minh",
            orderDetails: [
                OrderDetail(plantId: plant.id,
                            rentalStartDate: selectedDate,
                            numberMonth: numberOfMonth)
            ]
        )
        
        APIManager.shared.createOrderRental(order: order)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.handleAPIError(error)
                    self.isAlertShowing = true
                }
            } receiveValue: { orderResponse in
                self.contractNumber = orderResponse.data.orderId
                self.isLinkActive = true
                self.createContract()
            }
            .store(in: &cancellables)
    }
    
    func createContract() {
        guard let plant = self.plant,
              let contractNumber = self.contractNumber
        else {
            return
        }
        
        let contractDetails = [
            ContractDetail(plantId: plant.id, totalPrice: rentTotalPrice())
        ]
        
        let contractRequest = ContractRequest(
            contractNumber: contractNumber,
            description: "Cho thuê \(plant.name)",
            creationContractDate: Date(),
            endContractDate: Date(),
            totalAmount: rentTotalAmount(),
            contractDetails: contractDetails
        )
        
        APIManager.shared.createContract(createContractRequest: contractRequest)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractId = contractResponse.contractId
                self.getContractById()
            }
            .store(in: &cancellables)
    }
    
    func getContractById() {
        guard let contractId = self.contractId else {
            return
        }
        
        APIManager.shared.getContractById(contractId: contractId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractUrl = contractResponse.data.contractUrl
            }
            .store(in: &cancellables)

    }
    
    func updatePaymentStatus(paymentId: Int) {
        guard let orderId = self.contractNumber,
              let contractId = self.contractId else {
            return
        }
        
        // MARK: - CONTRACT NUMBER = ORDER ID
        APIManager.shared.updatePaymentOrderRental(orderId: orderId, contractId: contractId, paymentId: paymentId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.message = "Đơn hàng đã thanh toán thành công"
                    self.isAlertShowing = true
                case .failure(let error):
                    self.handleAPIError(error)
                    self.isAlertShowing = true
                }
            } receiveValue: {}
            .store(in: &cancellables)

    }
    
    // MARK: - BuyItemDetailScreen
    func createOrder() {
        guard let plant = self.plant,
        let deliveriteFree = self.deliveriteFree else {
            return
        }
        
        let orderDetails: [Plant] = [plant]
        
        let createOrderRequest = CreateOrderRequest(totalPrice: plant.price, deliveryFee: deliveriteFree, deliveryAddress: "Địa chỉ FIXXXXXX", paymentId: self.selectedPaymentMethod == .cashOnDelivery ? 1 : 2, orderDetails: orderDetails)
        
        isLoading = true
        
        APIManager.shared.createOrder(createOrderRequest: createOrderRequest)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Thực thi thành công")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { statusCode, message in
                print(message)
            })
            .store(in: &cancellables)
    }
    
    func rentTotalAmount() -> Double {
        return ((self.plant?.price ?? 0) * Double(self.numberOfMonth)) + (self.deliveriteFree ?? 0)
    }
    
    func rentTotalPrice() -> Double {
        return ((self.plant?.price ?? 0) * Double(self.numberOfMonth)) + (self.deliveriteFree ?? 0)
    }
    
    func totalPrice() -> Double {
        return (self.plant?.price ?? 0) + (self.deliveriteFree ?? 0)
    }
    
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .networkError:
                self.message = "Không thể kết nối tới mạng."
            case .serverError(let statusCode):
                self.message = "Lỗi từ server: \(statusCode)"
            case .decodingError:
                self.message = "Dữ liệu trả về không hợp lệ."
            case .custom(let message):
                self.message = message
            case .dataNotFound:
                self.message = "Không tìm thấy dữ liệu"
            case .failedToGetData:
                self.message = "Không lấy được dữ liệu"
            case .badUrl:
                self.message = "Lỗi kết nối đến server"
            case .transportError:
                self.message = "Lỗi đường truyền"
            case .invalidResponse:
                self.message = "Dữ liệu trả về bị lỗi"
            case .noData:
                self.message = "Không có dữ liệu trả về"
            case .unexpectedError:
                self.message = "Lỗi không xác định, vui lòng thử lại sau."
            }
        } else {
            self.message = "Lỗi không xác định, vui lòng thử lại sau."
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
