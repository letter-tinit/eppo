//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI
import Observation
import Combine

@Observable
class ReviewRentalPlantViewModel {
    var plant: Plant
    var orderId: Int
    var rentTotalPrice: Double
    var rentTotalAmount: Double
    var deliveriteFree: Double
    var deliveryAddress: String
    var contractId: Int?
    var contractUrl: String?
    var isAlertShowing: Bool = false
    var message: String = ""
    var isSigned: Bool = false
    
    
    var loadingMessage: String = ""
    var isContactLoading: Bool = false
    var isLoading: Bool = false

    var cancellables: Set<AnyCancellable> = []
    
    init(plant: Plant, orderId: Int, rentTotalPrice: Double, rentTotalAmount: Double, deliveriteFree: Double, deliveryAddress: String) {
        self.plant = plant
        self.orderId = orderId
        self.rentTotalPrice = rentTotalPrice
        self.rentTotalAmount = rentTotalAmount
        self.deliveriteFree = deliveriteFree
        self.deliveryAddress = deliveryAddress
    }
    
    func createContract() {
        loadingMessage = "Đang tạo hợp đồng"
        isContactLoading = true
        let contractDetails = [
            ContractDetail(plantId: plant.id, totalPrice: rentTotalPrice)
        ]
        
        let contractRequest = ContractRequest(
            contractNumber: orderId,
            description: "Cho thuê \(plant.name)",
            creationContractDate: Date(),
            endContractDate: Date(),
            totalAmount: rentTotalAmount,
            contractDetails: contractDetails
        )
        
        APIManager.shared.createContract(createContractRequest: contractRequest)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.loadingMessage = "Tạo hợp đồng thất bại"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isContactLoading = false
                    }
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
    
    func getShippingFeeByPlantId() {
        APIManager.shared.getShippingFee(plantId: plant.id)
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
    
    func updatePaymentStatus(paymentId: Int) {
        isLoading = true
        guard let contractId = self.contractId else {
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

