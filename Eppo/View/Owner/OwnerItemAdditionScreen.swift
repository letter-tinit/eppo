//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import UIKit
import PhotosUI

struct OwnerItemAdditionScreen: View {
    @StateObject private var viewModel = OwnerItemAdditionViewModel()
    @State private var mainImagePickerItem: PhotosPickerItem? = nil
    @State private var additionalImagePickerItems: [PhotosPickerItem] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            SingleHeaderView(title: "Thêm sản phẩm")
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("Tên sản phẩm").font(.headline)
                        BorderTextField {
                            TextField("Nhập tên", text: $viewModel.itemName)
                        }
                        .frame(height: 50)
                        
                        Text("Tiêu đề phụ").font(.headline)
                        BorderTextField {
                            TextField("Nhập tiêu đề phụ", text: $viewModel.itemTitle)
                        }
                        .frame(height: 50)
                        
                        Text("Mô tả").font(.headline)
                        BorderTextField {
                            TextField("Nhập mô tả", text: $viewModel.itemDescription)
                        }
                        .frame(height: 50)

                        Text("Giá sản phẩm").font(.headline)
                        BorderTextField {
                            TextField("Nhập giá tiền", text: $viewModel.price)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                                            
                        Text("Kích thước (cm)").font(.headline)
                        HStack {
                            BorderTextField {
                                TextField("Rộng", text: $viewModel.width)
                                    .keyboardType(.numberPad)
                            }
                            .frame(height: 40)

                            BorderTextField {
                                TextField("Dài", text: $viewModel.length)
                                    .keyboardType(.numberPad)
                            }                
                            .frame(height: 40)

                            
                            BorderTextField {
                                TextField("Cao", text: $viewModel.height)
                                    .keyboardType(.numberPad)
                            }          
                            .frame(height: 40)

                        }
                    }
                    
                    // Main Image Picker
                    Text("Hình ảnh chính").font(.headline)
                    PhotosPicker(selection: $mainImagePickerItem, matching: .images) {
                        if let mainImage = viewModel.mainImage {
                            Image(uiImage: mainImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                    }
                    .onChange(of: mainImagePickerItem) { _, newValue in
                        Task {
                            await viewModel.handleMainImagePicker(newValue)
                        }
                    }
                    
                    // Additional Images Picker
                    Text("Hình ảnh bổ sung").font(.headline)
                    PhotosPicker(selection: $additionalImagePickerItems, matching: .images) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: additionalImagePickerItems) { _, newValue in
                        Task {
                            await viewModel.handleAdditionalImagesPicker(newValue)
                        }
                    }
                    
                    // Display Selected Additional Images
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.additionalImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
//                if viewModel.isValid {
                    viewModel.createOwnerItem()
//                } else {
//                    alertMessage = viewModel.validationMessage
//                    showAlert = true
//                }
            }) {
                Text("Xác nhận")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }    
}

// MARK: - PREVIEW
#Preview {
    OwnerItemAdditionScreen()
}
