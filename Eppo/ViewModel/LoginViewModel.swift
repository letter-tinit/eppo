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
            if let errorMessage = self.errorMessage {
                return true
            } else {
                return false
            }
        }
        
        set {}
    }
    var isLogged: Bool = false
    var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(userName: String, password: String) {
        isLoading = true
        
        APIManager.shared.login(username: userName, password: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.isPopupMessage = true
                    if let apiError = error as? APIErrorResponse {
                        // Handle API-specific error (e.g., unauthorized)
                        self.errorMessage = "Tài khoản hoặc mật khẩu không chính xác"
                    } else {
                        // Handle other errors (e.g., networking issues)
                        self.errorMessage = "Không kết nối được với server. Kiểm tra lại kết nối mạng"
                    }
                }
            }, receiveValue: { loginResponse in
                print(loginResponse.token)
                UserSession.shared.saveToken(loginResponse.token)
                self.errorMessage = nil
            })
            .store(in: &cancellables) // Store the cancellable
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
