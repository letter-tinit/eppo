//
//  RatingSubmitViewModel.swift
//  Eppo
//
//  Created by Letter on 30/11/2024.
//

import Foundation
import Combine
import Observation
import PhotosUI
import SwiftUI

@Observable
class RatingSubmitViewModel {
    let plantId: Int
    var rating: Int = 0
    var textRating = ""
    var textLimit: Int = 300
    var additionalImages: [UIImage] = []
    private let maxImages = 5
    
    private var cancellables: Set<AnyCancellable> = []
    
    var isLoading = false
    var isAlertShowing = false
    var errorMessage = ""
    
    init(plantId: Int) {
        self.plantId = plantId
    }
    
    func submitRating() {
        isLoading = true
        APIManager.shared.createFeedback(description: textRating, plantId: plantId, rating: rating, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.errorMessage = "Đã đánh giá thành công"
                    self.isAlertShowing = true
                    print("Đã cập nhật trạng thái thành công")
//                    self.isRequestSucesss = true
                case .failure(let error):
                    self.errorMessage = "Đánh giá thất bại"
                    print("Unexpected error: \(error)")
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func handleAdditionalImagesPicker(_ selectedItems: [PhotosPickerItem]) async {
        additionalImages.removeAll()
        for selectedItem in selectedItems.prefix(maxImages) {
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                additionalImages.append(image)
            }
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
