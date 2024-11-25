//
//  SignUpViewModel.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class SignUpViewModel {
    let fakeSignUpUser = SignUpUser(
        userName: "john_doe3",
        fullName: "John Doe3",
        password: "123",
        confirmPassword: "123",
        gender: "Nam",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
        phoneNumber: "0987654321",
        addressDescription: "123 Nguyễn Huệ, Quận 1, TP.HCM",
        email: "johndoe3@example.com",
        identificationCard: "123456789",
        role: "Người bán"
    )
    
    var signUpUser: SignUpUser
    var message: String = ""
    var isAlertShowing: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.signUpUser = SignUpUser(userName: "", fullName: "", password: "", confirmPassword: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", addressDescription: "", email: "", identificationCard: "", role: "Người bán")
    }
    
    func signUpAccount() {
//        guard signUpUser.isPasswordMatch() else {
//            isAlertShowing = true
//            message = "Mật khẩu và xác thực không giống nhau"
//            return
//        }
//        
//        guard signUpUser.isAllFieldsInputted() else {
//            isAlertShowing = true
//            message = "Bạn chưa điền đủ tất cả thông tin"
//            return
//        }
        
        if signUpUser.role == "Người bán" {
            createOwner()
        } else {
            createCustomer()
        }
        
    }
    
    private func createOwner() {
        APIManager.shared.createOwner(signUpUser: fakeSignUpUser)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.message = "Tài khoản đã tạo thành công"
                    self?.isAlertShowing = true
                    break
                case .failure(let error):
                    self?.handleAPIError(error)
                    self?.isAlertShowing = true
                }
            } receiveValue: { signUpResponse in
            }
            .store(in: &cancellables)
    }
    
    private func createCustomer() {
        APIManager.shared.createCustomer(signUpUser: fakeSignUpUser)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.message = "Tài khoản đã tạo thành công"
                    self?.isAlertShowing = true
                    break
                case .failure(let error):
                    self?.handleAPIError(error)
                    self?.isAlertShowing = true
                }
            } receiveValue: { signUpResponse in
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
}
