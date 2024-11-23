//
//  AddressViewModel.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

import Foundation
import Combine
import Observation

@Observable
class AddressViewModel {
    var cancellables: Set<AnyCancellable> = []
    var addressTextField: String = ""
    var addresses: [Address] = []
    var message: String?
    var isShowingAlert: Bool = false
    var isLoading: Bool = false
    var isPopup: Bool = false
    var hasError = false
    
    func getAddress() {
        isLoading = true
        hasError = false
        
        APIManager.shared.getAddress()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleAPIError(error)
                    self?.hasError = true
                }
            } receiveValue: { addressResponse in
                self.addresses = addressResponse.data
            }
            .store(in: &cancellables)
    }
    
    func createAddress() {
        isLoading = true
        APIManager.shared.createAddress(createAddressResponse: CreateAddessRequest(description: self.addressTextField))
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.message = "Đã tạo thành công"
                    self?.isShowingAlert = true
                    self?.getAddress()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.message = error.localizedDescription
                }
            } receiveValue: { createAddressResponse in
                print(createAddressResponse)
                self.message = createAddressResponse.message
            }
            .store(in: &cancellables)
    }
    
    func deleteAddress(by addressId: Int) {
        isLoading = true
        APIManager.shared.deleteAddress(addressId: addressId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.message = "Xoá thành công"
                    self.isShowingAlert = true
                    self.getAddress()
                    break
                case .failure(let error):
                    self.handleAPIError(error)
                }
            } receiveValue: {}
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
}
