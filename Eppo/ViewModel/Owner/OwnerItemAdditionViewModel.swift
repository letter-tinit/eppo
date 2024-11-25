//
//  OwnerItemAdditionViewModel.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import Foundation
import Observation
import SwiftUI
import Combine
import PhotosUI

enum SelectionTypeEcommerce: String, CaseIterable, Identifiable {
    case buy = "Bán"
    case hire = "Cho thuê"
    case auction = "Đấu giá"
    
    var id: Self { self }
}

class OwnerItemAdditionViewModel: ObservableObject {
    // MARK: - Properties
    @Published var itemName: String = ""
    @Published var itemTitle: String = ""
    @Published var itemDescription: String = ""
    @Published var price: String = ""
    @Published var width: String = ""
    @Published var length: String = ""
    @Published var height: String = ""
    @Published var categoryId: String = ""
    
    @Published var mainImage: UIImage? = nil
    @Published var additionalImages: [UIImage] = []
    @Published var selectedEType: SelectionTypeEcommerce = .buy
    
    private let maxImages = 5
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Validation
    var isValid: Bool {
        guard !itemName.isEmpty,
              !itemDescription.isEmpty,
              let _ = Double(price), // Ensure price is a valid number
              !width.isEmpty,
              !length.isEmpty,
              !height.isEmpty,
              mainImage != nil else {
            return false
        }
        return true
    }
    
    @Published var isLoading: Bool = false
    @Published var isAlertShowing: Bool = false
    @Published var message: String?
    
    //    let plantData: [String: String] = [
    //        "typeEcommerceId": "\(1)", // Thay bằng dữ liệu thực tế
    //        "width": "\(150)",
    //        "length": "\(150)",
    //        "height": "\(150)",
    //        "finalPrice": "\(5000000)",
    //        "plantName": "Mobile Demo",
    //        "title": "Mobile Demo",
    //        "categoryId": "\(1)",
    //        "description": "Mobile Demo"
    //    ]
    
    func createOwnerItem() {
        isLoading = true
        var typeEcommerceId = 1
        
        switch selectedEType {
        case .buy:
            typeEcommerceId = 1
        case .hire:
            typeEcommerceId = 2
        case .auction:
            typeEcommerceId = 3
        }
        
        // Dữ liệu hardcode cho các trường ngoài hình ảnh
        let plantData: [String: String] = [
            "typeEcommerceId": "\(typeEcommerceId)", // Ví dụ Ecommerce type
            "width": "100", // Ví dụ giá trị
            "length": "100", // Ví dụ giá trị
            "height": "100", // Ví dụ giá trị
            "finalPrice": "200", // Ví dụ giá trị
            "plantName": "Sample Plant", // Ví dụ tên cây
            "title": "Sample Plant Title", // Ví dụ tiêu đề
            "categoryId": "1", // Ví dụ category ID
            "description": "This is a sample description" // Ví dụ mô tả
        ]
        
//        let plantData: [String: String] = [
//            "typeEcommerceId": "\(typeEcommerceId)", // Ví dụ Ecommerce type
//            "width": width, // Ví dụ giá trị
//            "length": length, // Ví dụ giá trị
//            "height": height, // Ví dụ giá trị
//            "finalPrice": price, // Ví dụ giá trị
//            "plantName": itemName, // Ví dụ tên cây
//            "title": itemTitle, // Ví dụ tiêu đề
//            "categoryId": categoryId, // Ví dụ category ID
//            "description": itemDescription // Ví dụ mô tả
//        ]
        
        // Gọi API để tạo OwnerItem
        APIManager.shared.createPlant(
            plantData: plantData,
            mainImage: mainImage,
            additionalImages: additionalImages
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                self.message = "Đã tạo cây thành công"
                self.isAlertShowing = true
                print("Đã tạo cây thành công")
            case .failure(let error):
                switch error {
                case .networkError:
                    print("Network error occurred. Please check your connection.")
                    self.message = "Lỗi mạng, vui lòng kiểm tra lại"
                case .serverError(let statusCode):
                    print("Server error occurred. Status code: \(statusCode)")
                    self.message = "Lỗi server"
                case .noData:
                    self.message = "Không có dữ liệu trả về"
                    print("No data returned from server.")
                case .custom(let message):
                    self.message = message
                    print(message)
                default:
                    self.message = "Lỗi không xác định: \(error)"
                    print("Unexpected error: \(error)")
                }
                self.isAlertShowing = true
            }
        }, receiveValue: { response in
            // Xử lý response thành công
            print("Owner item created successfully: \(response)")
        })
        .store(in: &cancellables)
    }
    
    var validationMessage: String {
        if itemName.isEmpty { return "Tên sản phẩm không được để trống." }
        if itemDescription.isEmpty { return "Mô tả không được để trống." }
        if price.isEmpty || Double(price) == nil { return "Giá phải là một số hợp lệ." }
        if width.isEmpty { return "Chiều rộng không được để trống." }
        if length.isEmpty { return "Chiều dài không được để trống." }
        if height.isEmpty { return "Chiều cao không được để trống." }
        if mainImage == nil { return "Vui lòng chọn hình ảnh chính." }
        return ""
    }
    
    // MARK: - Image Selection
    func handleMainImagePicker(_ selectedItem: PhotosPickerItem?) async {
        guard let selectedItem = selectedItem else { return }
        if let data = try? await selectedItem.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            mainImage = image
        }
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
}

