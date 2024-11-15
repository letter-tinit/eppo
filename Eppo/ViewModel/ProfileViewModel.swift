//
//  ProfileViewModel.swift
//  Eppo
//
//  Created by Letter on 05/10/2024.
//

import Foundation
import Combine
import Observation

@Observable
class ProfileViewModel {
    
    var userResponse: UserResponse?
    
    var originalUserResponse: UserResponse?
    
    var cancellables: Set<AnyCancellable> = []
    
    var message: String?
    
    var createUserRequest: User = User()
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
                self.userResponse = userResponse
                self.originalUserResponse = userResponse
                self.usernameTextField = userResponse.data.fullName ?? "Đang tải"
                self.phoneNumberTextField = userResponse.data.phoneNumber ?? "Đang tải"
                self.emailTextField = userResponse.data.email ?? "Đang tải"
                self.idCodeTextField = String(userResponse.data.identificationCard ?? 0)
//                self.date = convertStringToDate(userResponse.data.dateOfBirth ?? "")
            }
            .store(in: &cancellables)
    }
    
//    var usernameTextField: String = ""
//    var phoneNumberTextField: String = ""
//    var emailTextField: String = ""
//    //    var addressTextField: String = ""
//    var idCodeTextField: String = ""
//    var date = Date()
//    var isFemale: Bool = false
//    var isMale: Bool = true
//    var isSelectedDate: Bool = false
//    var isShowingAlert: Bool = false
//    var isPopup: Bool = false
    
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
    
    func dayOfBirth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let dateOfBirth = self.userResponse?.data.dateOfBirth else {
            return nil
        }
        
        let date = dateFormatter.date(from: dateOfBirth)
        
        return reformatDateStringToPassing(date ?? Date())
    }
    
    func reformatDateStringToPassing(_ date: Date) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        return outputFormatter.string(from: date)
    }
    
    func getAddress() {
        APIManager.shared.getAddress()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.handleAPIError(error)
                }
            } receiveValue: { addressResponse in
                self.addresses = addressResponse.data
            }
            .store(in: &cancellables)
    }
    
    func createAddress() {
        APIManager.shared.createAddress(createAddressResponse: CreateAddessRequest(description: self.addressTextField))
            .sink { completion in
                self.isShowingAlert = true
                switch completion {
                case .finished:
                    self.getAddress()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.message = error.localizedDescription
                }
            } receiveValue: { createAddressResponse in
                print(createAddressResponse)
                self.message = createAddressResponse.message
            }
            .store(in: &cancellables)
    }
    
    func deleteAddress(by addressId: Int) {
        APIManager.shared.deleteAddress(addressId: addressId)
            .sink { completion in
                self.isShowingAlert = true
                switch completion {
                case .finished:
                    self.message = "Xoá thành công"
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
    
    func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        // Set the locale and the date style for default format
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .medium  // This is a common default format (e.g., "Jan 1, 2024")
        dateFormatter.timeStyle = .none   // No time needed, just the date
        
        return dateFormatter.string(from: date)
    }

    func convertStringToDate(_ dateString: String, dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        
        // Set the date format of the string you are converting
        dateFormatter.dateFormat = dateFormat
        
        // Return the Date object if conversion succeeds, otherwise nil
        return dateFormatter.date(from: dateString)
    }
    
    func logout() {
        UserSession.shared.clearSession()
    }
}
