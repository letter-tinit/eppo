//
//  LoginViewModel.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

import Foundation
import Combine

@Observable class LoginViewModel {
    var isShowingPassword: Bool = false
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
    
    var isCustomer: Bool = false {
        didSet {
            if isCustomer { isOwner = false }
        }
    }
    var isOwner: Bool = false {
        didSet {
            if isOwner { isCustomer = false }
        }
    }
    var isSigned: Bool = true

    private var cancellables = Set<AnyCancellable>()
    
    enum Role: String {
        case customer
        case owner
        case unknown
        
        static func from(roleName: String) -> Role {
            return Role(rawValue: roleName) ?? .unknown
        }
    }
    
    func login(userName: String, password: String) {
        isLoading = true
        isCustomer = false
        isOwner = false
        isLogged = false
        errorMessage = nil
        
        APIManager.shared.login(username: userName.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines))
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
                let role = Role.from(roleName: loginResponse.roleName)
                self.handleRole(role: role, token: loginResponse.token)
                if let isSigned = loginResponse.isSigned,
                   !isSigned {
                    self.isSigned = isSigned
                }
            })
            .store(in: &cancellables)
    }
    
    func getMyInformation() {
        APIManager.shared.getMyInformation()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { userResponse in
                UserSession.shared.myInformation = userResponse.data
            }
            .store(in: &cancellables)
    }
    
    private func handleRole(role: Role, token: String) {
        switch role {
        case .customer:
            UserSession.shared.saveToken(token)
            isCustomer = true
            isLogged = true
            errorMessage = nil
        case .owner:
            UserSession.shared.saveToken(token)
            isOwner = true
            isLogged = true
            errorMessage = nil
        case .unknown:
            errorMessage = "Vai trò không hợp lệ hoặc không được hỗ trợ."
            isPopupMessage = true
        }
        isLoading = false
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
    
    func checkIsOwner(roleName: String) -> Bool {
        if roleName == "owner" {
            return true
        } else {
            return false
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
