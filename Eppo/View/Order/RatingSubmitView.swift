//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI

struct RatingSubmitView: View {
    // MARK: - PROPERTY
    @State var rating: Int = 0
    @State var textRating = ""
    
    var itemName: String
    var itemType: String
    
    var textLimit: Int = 300
    
    @State private var attachImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomHeaderView(title: "Viết đánh giá")
            
            HStack(alignment: .bottom) {
                // Item Image
                Image("sample-bonsai")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
                
                VStack(alignment: .leading) {
                    Text(itemName)
                        .font(.headline)
                        .lineLimit(1)

                    Text(itemType)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                    
                    RatingStarSubmitionView(rating: $rating)
                }
                
                Spacer()
            }
            .padding(10)
            
            Divider()
            
            Text("Đánh giá bài viết")
                .font(.headline)
                .padding(10)
                .foregroundStyle(.blue)

            TextEditor(text: $textRating)
                .onChange(of: textRating) { newValue, oldValue in
                    if newValue.count > textLimit {
                        textRating = String(newValue.prefix(textLimit))
                    }
                    print(textRating)
                }
                .scrollContentBackground(.hidden)
                .padding(10)
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.mint, lineWidth: 3)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: UIColor.systemGray6)))
                )
                .foregroundStyle(.black)
                .tint(.black)
                .padding(10)
                .overlay(alignment: .bottomTrailing) {
                    Text("\(textRating.count)/ \(textLimit)")
                        .padding([.bottom, .trailing])
                        .foregroundStyle(.darkBlue)
                }
            
            HStack(alignment: .top) {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    VStack(alignment: .center) {
                        Text("Thêm ảnh")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "photo.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .font(.headline)
                    .foregroundStyle(.green)
                }
                
                Spacer()
                
                Image(
                    uiImage: attachImage ?? UIImage(resource: .photoAddition)
                )
                .resizable()
                .frame(width: 200, height: 140)
                .scaledToFit()
                .border(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            Button {

            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 60)
                        .foregroundStyle(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    Text("Gửi đánh giá")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .fontDesign(.rounded)
                }
                .padding()
                
            } // SUBMIT RATING BUTTON
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .navigationBarBackButtonHidden()
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                if let photoPickerItem,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        attachImage = image
                    }
                }
                
                photoPickerItem = nil
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RatingSubmitView(itemName: "Cây cảnh phong thuỷ đã tạo kiểu", itemType: "Đã tạo kiểu")
}
