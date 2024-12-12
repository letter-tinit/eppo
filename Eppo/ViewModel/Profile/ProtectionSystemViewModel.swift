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
    
    func forgetPassword() {
        
    }
    
    private func showAlert(activeAlert: ProtectionSystemActiveAlert, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activeAlert = activeAlert
            self?.message = message
            self?.isShowingAlert = true
        }
    }
}
