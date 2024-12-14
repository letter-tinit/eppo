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
    
    var user: User
    
    var cancellables: Set<AnyCancellable> = []
    
    var message: String?
    
    // MARK: - MY ACCOUNT SCREEN BINDING
    var isShowingAlert: Bool = false
    var isPopup: Bool = false
    
    // MARK: - TRANSACTION HISTORY SCREEN
    var transactions: [TransactionAPI] = []
    
    // MARK: - AUCTION HISTORY SCREEN
    var auctions: [HistoryRoom] = []
    
    // MARK: - Trạng thái cho UI
    var isLoading = false
    var hasError = false
    var errorMessage: String?
    
    init() {
        self.user = User(userId: 1, userName: "", fullName: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", email: "", imageUrl: "", identificationCard: "")
    }
    
    func getMyInformation() {
        isLoading = true
//        APIManager.shared.getMyInformationTest()
//            .sink { completion in
//                self.isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { userResponse in
//                print(userResponse as Any)
//            }
//            .store(in: &cancellables)
        
        APIManager.shared.getMyInformation()
            .sink { completion in
                self.isLoading = false
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
        
    func getTransactionHistory() {
        isLoading = true
        hasError = false
        errorMessage = nil
        
        guard let walletId = UserSession.shared.myInformation?.wallet?.walletId else {
            return
        }
        
        APIManager.shared.getTransactionHistory(pageIndex: 1, pageSize: 999, walletId: walletId)
            .timeout(.seconds(1), scheduler: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.hasError = true
                    self.handleAPIError(error)
                }
            } receiveValue: { transactions in
                print(transactions)
                self.transactions = transactions
            }
            .store(in: &cancellables)
    }
    
    func getHistoryAuction() {
        isLoading = true
        hasError = false
        errorMessage = nil
        
        APIManager.shared.getHistoryAuction(pageIndex: 1, pageSize: 999)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                    self.hasError = true
                    self.handleAPIError(error)
                }
            } receiveValue: { historyRoomResponse in
                print(historyRoomResponse.data)
                self.auctions = historyRoomResponse.data
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
    
    func logout() {
        UserSession.shared.clearSession()
    }
}
