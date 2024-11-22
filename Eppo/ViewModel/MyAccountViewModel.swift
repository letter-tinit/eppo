//
//  MyAccountViewModel.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation
import Combine
import Observation
import SwiftUI
import PhotosUI

@Observable
class MyAccountViewModel {
    var userInput: User
    var avatar: UIImage? = nil
    var cancellables: Set<AnyCancellable> = []
    
    var isLoading: Bool = false
    var isAlertShowing: Bool = false
    var message: String = "Nhắc nhở"
    
    init(userInput: User) {
        self.userInput = userInput
    }
    
    func isValid() -> Bool {
        return userInput.isAllFieldsInputted()
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
                self.userInput = userResponse.data
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Image Selection
    func handleAvatarImagePicker(_ selectedItem: PhotosPickerItem?) async {
        guard let selectedItem = selectedItem else { return }
        if let data = try? await selectedItem.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            avatar = image
        }
    }
    
    func updateUserInformation() {
        isLoading = true
        
        // Gọi API updateUserInformation và xử lý kết quả
        APIManager.shared.updateUserInformation(userInput: userInput, avatar: avatar)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    print("Update successful")
                    self?.message = "Cập nhật thành công"
                    self?.isAlertShowing = true
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                    self?.message = error.localizedDescription
                    self?.isAlertShowing = true
                }
            } receiveValue: { response in
                // Xử lý phản hồi sau khi cập nhật thành công
                print("User updated successfully: \(response)")
                // Cập nhật lại dữ liệu nếu cần
                self.userInput = response.data
            }
            .store(in: &cancellables)
    }
}
