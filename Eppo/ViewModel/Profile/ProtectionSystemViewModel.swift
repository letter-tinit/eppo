//
//  ProtectionSystemViewModel.swift
//  Eppo
//
//  Created by Letter on 08/12/2024.
//

import Foundation
import Combine
import Observation

enum ProtectionSystemActiveAlert: String {
    case remind = "Nhắc nhở"
    case error = "Có lỗi xảy ra"
    case success = "Thành công"
}

@Observable
class ProtectionSystemViewModel {
    var oldPassword: String = ""
    var newPassword: String = ""
    var email: String = ""
    var isShowingPassword: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ALERT COMPONENTS
    var activeAlert: ProtectionSystemActiveAlert = .remind
    var message: String?
    var isShowingAlert: Bool = false
    var isShowingPopover: Bool = false

    func isEmptyInput() -> Bool {
        return oldPassword.isEmpty || newPassword.isEmpty
    }
    
    func changePassword() {
        guard !isEmptyInput() else {
            showAlert(activeAlert: .error, message: "Vui lòng nhập đầy đủ thông tin")
            return
        }
        
        // CHANGE PASSWORD
        
        showAlert(activeAlert: .success, message: "Đã thay đổi thành công")
        
    }
    
    func forgetPassword(completion: @escaping (Result<String, Error>) -> Void) {
        APIManager.shared.forgetPassword(email: email)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        print("Request finished")
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        completion(.failure(error)) // Pass the error to the completion handler
                    }
                },
                receiveValue: { message in
                    // Send the result to the completion handler
                    completion(.success(message))
                }
            )
            .store(in: &cancellables)
    }
    
    private func showAlert(activeAlert: ProtectionSystemActiveAlert, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activeAlert = activeAlert
            self?.message = message
            self?.isShowingAlert = true
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
