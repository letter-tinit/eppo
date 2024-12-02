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
    var addresses: [Address] = []
    var selectedAddress: Address?
    
    var feedBacks: [FeedBack] = []
    var averageRating: Double = 0
    var numberOfFeedbacks = 0
    
    // MARK: - HireItemDetailScreen
    var selectedDate = Date()
    var numberOfMonth = 1
    let step = 1
    let range = 1...99
    var deliveriteFree: Double = 0.0
    var contractNumber: Int?
    var contractId: Int?
    var contractUrl: String?
    var isSigned: Bool = false
    var isLinkActive = false
    
    // MARK: - BuyItemDetailScreen
    var selectedPaymentMethod: PaymentMethod = .cashOnDelivery
    
    var isFinishPayment: Bool = false
    
    // MARK: - CONTRACTSCREEN
    var loadingMessage: String = ""
    var isContactLoading: Bool = false

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
                self.getShippingFeeByPlantId()
            }
            .store(in: &cancellables)
    }
    
    func getFeedbacks(plantId: Int) {
        APIManager.shared.plantFeedBack(pageIndex: 1, pageSize: 999, plantId: plantId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.feedBacks.removeAll()
                }
            } receiveValue: { [weak self] feedBackAPIResponse in
                self?.averageRating = feedBackAPIResponse.data.totalRating / Double(feedBackAPIResponse.data.numberOfFeedbacks)
                self?.numberOfFeedbacks = feedBackAPIResponse.data.numberOfFeedbacks
                self?.feedBacks = feedBackAPIResponse.data.feedbacks
                print(self?.feedBacks as Any)
            }
            .store(in: &cancellables)

    }
    
    func getShippingFeeByPlantId() {
        guard let plantId = plant?.id else {
            return
        }
        
        APIManager.shared.getShippingFee(plantId: plantId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { shippingFeeResponse in
                self.deliveriteFree = shippingFeeResponse.data
            }
            .store(in: &cancellables)
    }
    
    func getAddress() {
        isLoading = true
        
        APIManager.shared.getAddress()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleAPIError(error)
                }
            } receiveValue: { addressResponse in
                self.addresses = addressResponse.data
                self.selectedAddress = self.addresses.first
            }
            .store(in: &cancellables)
    }
    
    // MARK: - HireItemDetailScreen
    
    func createOrderRental() {
        isContactLoading = true
        loadingMessage = "Đang tạo đơn hàng"
        guard let plant = self.plant,
//              let deliveriteFree = self.deliveriteFree,
              let addressDescription = self.selectedAddress?.description else {
            self.loadingMessage = "Tạo đơn hàng thất bại"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isContactLoading = false
            }
            return
        }
        
        let order = Order(
            totalPrice: rentTotalPriceWithoutDeliveriteFree(),
            deliveryFee: deliveriteFree,
            deliveryAddress: addressDescription,
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
                    self.loadingMessage = "Tạo đơn hàng thất bại"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isContactLoading = false
                    }
                }
            } receiveValue: { orderResponse in
                self.contractNumber = orderResponse.data.orderId
                self.isLinkActive = true
                self.loadingMessage = "Tạo đơn hàng thành công"
                self.createContract()
            }
            .store(in: &cancellables)
    }
    
    func createContract() {
        loadingMessage = "Đang tạo hợp đồng"
        guard let plant = self.plant,
              let contractNumber = self.contractNumber
        else {
            self.loadingMessage = "Tạo hợp đồng thất bại"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isContactLoading = false
            }
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
                    self.loadingMessage = "Tạo hợp đồng thất bại"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isContactLoading = false
                    }
                    print(error.localizedDescription)
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractId = contractResponse.contractId
                self.loadingMessage = "Đã tạo hợp đồng thành công"
                self.getContractById()
            }
            .store(in: &cancellables)
    }
    
    func getContractById() {
        self.loadingMessage = "Đang tải hợp đồng"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isContactLoading = false
        }
        guard let contractId = self.contractId else {
            self.loadingMessage = "Tải hợp đồng thất bại"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isContactLoading = false
            }
            return
        }
        
        APIManager.shared.getContractById(contractId: contractId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.loadingMessage = "Tải hợp đồng thất bại"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isContactLoading = false
                    }
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractUrl = contractResponse.data.contractUrl
                self.loadingMessage = "Tải hợp đồng thành công"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isContactLoading = false
                }
            }
            .store(in: &cancellables)

    }
    
    func updatePaymentStatus(paymentId: Int) {
        isLoading = true
        guard let orderId = self.contractNumber,
              let contractId = self.contractId else {
            return
        }
        
        // MARK: - CONTRACT NUMBER = ORDER ID
        APIManager.shared.updatePaymentOrderRental(orderId: orderId, contractId: contractId, paymentId: paymentId)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.handleAPIError(error)
                    self.isAlertShowing = true
                }
            } receiveValue: { response in
                if (200...300).contains(response.statusCode) {
                    print(response)
                    self.message = "Đơn hàng đã thanh toán thành công"
                    self.isAlertShowing = true
                } else {
                    self.message = response.message
                    self.isAlertShowing = true
                }
            }
            .store(in: &cancellables)

    }
    
    // MARK: - BuyItemDetailScreen
    func createOrder() {
        isLoading = true
        
        guard let plant = self.plant,
//              let deliveriteFree = self.deliveriteFree,
              let addressDescription = self.selectedAddress?.description else {
            return
        }
        
        let orderDetails: [Plant] = [plant]
        
        let createOrderRequest = CreateOrderRequest(totalPrice: plant.finalPrice, deliveryFee: deliveriteFree, deliveryAddress: addressDescription, paymentId: self.selectedPaymentMethod == .cashOnDelivery ? 1 : 2, orderDetails: orderDetails)
        
        APIManager.shared.createOrder(createOrderRequest: createOrderRequest)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Thực thi thành công")
                    self.isFinishPayment = true
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                print(response)
                self.message = response.message
                self.isAlertShowing = true
            })
            .store(in: &cancellables)
    }
    
    func rentTotalAmount() -> Double {
        return ((self.plant?.finalPrice ?? 0) * Double(self.numberOfMonth)) + self.deliveriteFree
    }
    
    func rentTotalPrice() -> Double {
        return ((self.plant?.finalPrice ?? 0) * Double(self.numberOfMonth)) + self.deliveriteFree
    }
    
    func rentTotalPriceWithoutDeliveriteFree() -> Double {
        return ((self.plant?.finalPrice ?? 0) * Double(self.numberOfMonth))
    }
    
    func totalPrice() -> Double {
        return (self.plant?.finalPrice ?? 0) + self.deliveriteFree
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
