//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI

struct RatingSubmitView: View {
    // MARK: - PROPERTY
    @State var viewModel: RatingSubmitViewModel
    
    @State private var additionalImagePickerItems: [PhotosPickerItem] = []
    
    
    init(viewModel: RatingSubmitViewModel) {
        self.viewModel = viewModel
    }
  
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomHeaderView(title: "Viết đánh giá")
            
            Text("Đánh giá bài viết")
                .font(.headline)
                .padding(10)
                .foregroundStyle(.blue)
            
            TextEditor(text: $viewModel.textRating)
                .onChange(of: viewModel.textRating) { newValue, oldValue in
                    if newValue.count > viewModel.textLimit {
                        viewModel.textRating = String(newValue.prefix(viewModel.textLimit))
                    }
                    print(viewModel.textRating)
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
                    Text("\(viewModel.textRating.count)/\(viewModel.textLimit)")
                        .padding([.bottom, .trailing])
                        .foregroundStyle(.darkBlue)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Hoàn tất") {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        .fontWeight(.medium)
                    }
                }
            
            RatingStarSubmitionView(rating: $viewModel.rating)
                .padding(10)
            
            // Additional Images Picker
            VStack(alignment: .leading) {
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
            .padding(.horizontal)
            
            Button {
                viewModel.submitRating()
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
                .padding(.top, 30)
                
            } // SUBMIT RATING BUTTON
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RatingSubmitView(viewModel: RatingSubmitViewModel(plantId: 1))
}
