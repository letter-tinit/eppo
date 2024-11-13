//
//  LoginViewModel.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

import Foundation
import Combine

@Observable class LoginViewModel {
    var errorMessage: String?
    var isPopupMessage: Bool {
        get {
            if self.errorMessage == nil {
                return false
            } else {
                return true
            }
        }
        
        set {}
    }
    var isLogged: Bool = false
    var isLoading: Bool = false
    var isCustomer: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(userName: String, password: String) {
        isLoading = true
        
        APIManager.shared.login(username: userName, password: password)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    // API request thành công
                    break
                case .failure(let error):
                    // Xử lý lỗi
                    self.handleAPIError(error)
                    self.isPopupMessage = true
                }
            }, receiveValue: { loginResponse in
                // Cập nhật dữ liệu vào ViewModel
                if self.checkIsCustomer(roleName: loginResponse.roleName) {
                    UserSession.shared.saveToken(loginResponse.token)
                    self.isCustomer = true
                    self.errorMessage = nil
                    self.isLoading = false
                    self.isLogged = true
                } else {
                    self.isLoading = false
                    self.isPopupMessage = true
                    self.errorMessage = "Tài khoản hoặc mật khẩu không chính xác"
                }
            })
            .store(in: &cancellables)
    }
    
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .networkError:
                self.errorMessage = "Không thể kết nối tới mạng."
            case .serverError(let statusCode):
                self.errorMessage = "Lỗi từ server: \(statusCode)"
            case .decodingError:
                self.errorMessage = "Dữ liệu trả về không hợp lệ."
            case .custom(let message):
                self.errorMessage = message
            case .dataNotFound:
                self.errorMessage = "Không tìm thấy dữ liệu"
            case .failedToGetData:
                self.errorMessage = "Không lấy được dữ liệu"
            case .badUrl:
                self.errorMessage = "Lỗi kết nối đến server"
            case .transportError:
                self.errorMessage = "Lỗi đường truyền"
            case .invalidResponse:
                self.errorMessage = "Dữ liệu trả về bị lỗi"
            case .noData:
                self.errorMessage = "Không có dữ liệu trả về"
            case .unexpectedError:
                self.errorMessage = "Lỗi không xác định, vui lòng thử lại sau."
            }
        } else {
            self.errorMessage = "Lỗi không xác định, vui lòng thử lại sau."
        }
    }
    
    
    func checkIsCustomer(roleName: String) -> Bool {
        if roleName == "customer" {
            return true
        } else {
            return false
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
