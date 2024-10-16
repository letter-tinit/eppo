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
                        print(apiError.localizedDescription)
                        self.errorMessage = "Tài khoản hoặc mật khẩu không chính xác"
                    } else {
                        // Handle other errors (e.g., networking issues)
                        self.errorMessage = "Không kết nối được với server. Kiểm tra lại kết nối mạng"
                    }
                }
            }, receiveValue: { loginResponse in
                print(loginResponse.token)
                if self.checkIsCustomer(token: loginResponse.token) {
                    UserSession.shared.saveToken(loginResponse.token)
                    self.errorMessage = nil
                    self.isLoading = false
                    self.isLogged = true
                } else {
                    self.isLoading = false
                    self.isPopupMessage = true
                    self.errorMessage = "Tài khoản hoặc mật khẩu không chính xác"
                }
            })
            .store(in: &cancellables) // Store the cancellable
    }
    
    func checkIsCustomer(token: String) -> Bool {
        if let user = decodeJWT(token: token) {
            if user.roleId == "5" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func decodeJWT(token: String) -> User? {
        // Split the JWT token into its parts (header, payload, signature)
        let segments = token.split(separator: ".")
        guard segments.count == 3 else {
            print("Invalid token")
            return nil
        }
        
        // Extract the payload part (second segment) and decode it
        let payloadSegment = segments[1]
        
        // Decode Base64URL encoded string
        var base64 = payloadSegment.replacingOccurrences(of: "-", with: "+")
                                       .replacingOccurrences(of: "_", with: "/")
        
        // Add padding if necessary
        switch base64.count % 4 {
        case 2: base64.append("==")
        case 3: base64.append("=")
        default: break
        }
        
        guard let payloadData = Data(base64Encoded: base64) else {
            print("Failed to decode base64")
            return nil
        }
        
        // Decode JSON data into a User object
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: payloadData)
            return user
        } catch {
            print("Failed to decode User: \(error)")
            return nil
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
