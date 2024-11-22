//
//  OwnerProfileViewModel.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation
import Combine
import Observation

@Observable
class OwnerProfileViewModel {
    var user: User

    var cancellables: Set<AnyCancellable> = []
    
    var message: String?
    
    // MARK: - MY ACCOUNT SCREEN BINDING
    var usernameTextField: String = ""
    var phoneNumberTextField: String = ""
    var emailTextField: String = ""
    //    var addressTextField: String = ""
    var idCodeTextField: String = ""
    var date = Date()
    var isFemale: Bool = false
    var isMale: Bool = true
    var isSelectedDate: Bool = false
    var isShowingAlert: Bool = false
    var isPopup: Bool = false

    // MARK: - MY ADDRESS SCREEN BINDING
    var addressTextField: String = ""
    var addresses: [Address] = []
    
    // MARK: - Trạng thái cho UI
    var isLoading = false
    var hasError = false
    var errorMessage: String?
    
    init() {
        self.user = User(userId: 1, userName: "", fullName: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", email: "", imageUrl: "", identificationCard: "")
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
                self.user = userResponse.data
            }
            .store(in: &cancellables)
    }
  
    func updateInfomation() {
        
    }
    
    func setIsMale(_ isMale: Bool) {
        self.isMale = isMale
        self.isFemale = !isMale
    }
    
    func selectedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        return outputFormatter.string(from: self.date)
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
    
    func logout() {
        UserSession.shared.clearSession()
    }
}
