//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI

enum Gender {
    case male
    case female
    
    var isFemale: Bool {
        self == .female
    }
}

struct MyAccount: View {
    // MARK: - PROPERTY
    @State var viewModel: MyAccountViewModel
    @State private var mainImagePickerItem: PhotosPickerItem? = nil
    @State private var showPicker = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Tài Khoản Của Tôi")
            
            ScrollView(.vertical) {
                VStack {
                    PhotosPicker(selection: $mainImagePickerItem, matching: .images) {
                        if let mainImage = viewModel.avatar {
                            CircleImageView(image: Image(uiImage: mainImage), size: 140)
                        } else {
                            CustomCircleAsyncImage(imageUrl: viewModel.userInput.imageUrl, size: 140)
                                .foregroundStyle(.black)
                        }
                    }
                    .onChange(of: mainImagePickerItem) { _, newValue in
                        Task {
                            await viewModel.handleAvatarImagePicker(newValue)
                        }
                    }
                    .disabled(true)
                    .overlay(alignment: .bottomTrailing) {
                        EditAvatarButton {
                            showPicker = true
                        }
                    }
                    .padding()
                    .photosPicker(isPresented: $showPicker, selection: $mainImagePickerItem)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tên Đầy Đủ")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userInput.fullName, text: $viewModel.userInput.fullName)
                        }
                        .frame(height: 50)
                        
                        Text("Giới Tính")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        GenderSelector(selectedGender: $viewModel.userInput.gender)
                        
                        Text("Số Điện Thoại")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userInput.phoneNumber, text: $viewModel.userInput.phoneNumber)
                                .keyboardType(.numberPad)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Hoàn tất") {
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                        .fontWeight(.medium)
                                    }
                                }
                        }
                        .frame(height: 50)
                        
                        Text("Ngày Sinh")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        
                        BorderTextField {
                            Text(viewModel.userInput.dateOfBirth, format: .dateTime.day().month().year())
                                .foregroundStyle(.gray)
                                .overlay {
                                    DatePicker(selection: $viewModel.userInput.dateOfBirth, displayedComponents: .date) {}
                                        .labelsHidden()
                                        .contentShape(Rectangle())
                                        .opacity(0.011)
                                }
                        }
                        .frame(height: 50)
                        
                        Text("Email")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userInput.email, text: $viewModel.userInput.email)
                        }
                        .frame(height: 50)
                        
                        Text("Số CCCD")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(text: $viewModel.userInput.identificationCard) {
                                Text(viewModel.userInput.identificationCard)
                            }
                            .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                        
                        NavigationLink {
                            AddressScreen(viewModel: AddressViewModel())
                        } label: {
                            Text("Địa chỉ")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundStyle(.white)
                                .padding(.top)
                        }
                        
                        Spacer(minLength: 40)
                        
                        Button {
                            viewModel.updateUserInformation()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 60)
                                    .foregroundStyle(viewModel.isValid() ? .red : .gray
                                    )
                                
                                Text("Lưu")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .disabled(!viewModel.isValid())
                            
                        } // SAVE BUTTON
                    }
                    .padding(.horizontal)
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.bottom, 50)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .destructive(Text("Đóng")))
        }
    }
}

// MARK: - PREVIEW
#Preview {
    MyAccount(viewModel: MyAccountViewModel(userInput: User(userId: 1, userName: "", fullName: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", email: "", imageUrl: "", identificationCard: "")))
}
