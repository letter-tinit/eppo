//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI

struct OwnerItemAdditionScreen: View {
    // MARK: - PROPERTY
    @State private var itemName: String = ""
    @State private var itemDescription: String = ""
    
    @State private var selectedImages: [UIImage] = []
    @State private var photoPickerItems: [PhotosPickerItem] = []
    private let maxImages = 5
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            SingleHeaderView(title: "Thêm sản phẩm")
            
            VStack(alignment: .leading) {
                Text("Tên sản phẩm")
                    .foregroundStyle(.textDarkBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 20)
                
                BorderTextField {
                    TextField("Nhập tên", text: $itemName)
                }
                .frame(height: 50)
                
                Text("Mô tả")
                    .foregroundStyle(.textDarkBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 20)
                BorderTextField {
                    TextField("Nhập mô tả", text: $itemDescription)
                }
                .frame(height: 50)
                
                Text("Giá sản phẩm")
                    .foregroundStyle(.textDarkBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 20)
                
                BorderTextField {
                    HStack {
                        TextField("Nhập giá tiền", text: $itemDescription)
                            .keyboardType(.numberPad)
                        
                        Text("₫")
                            .font(.title)
                            .foregroundStyle(.orange)
                    }
                }
                .overlay(alignment: .trailing) {
                }
                .frame(height: 50)
                
                Text("Thêm hình ảnh")
                    .foregroundStyle(.textDarkBlue)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 20)
                
                PhotosPicker(selection: $photoPickerItems, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .font(.headline)
                        .foregroundStyle(.green)
                }
                .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .border(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .frame(height: 110)
            }
            .padding(.horizontal)
            .onChange(of: photoPickerItems) { _, _ in
                Task {
                    selectedImages.removeAll() // Reset the images
                    for photoPickerItem in photoPickerItems {
                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImages.append(image)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button {
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 60)
                        .foregroundStyle(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    Text("Đăng Ký")
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .bold))
                }
                .padding(.horizontal)
                
            } // LOGIN BUTTON
            
            Spacer()
            
        } // TEXT FIELD STACK
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerItemAdditionScreen()
}
