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
            CustomMyAccountHeaderView(title: "Tài Khoản Của Tôi")
            
            ZStack {
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
                            
                            Spacer(minLength: 30)
                            
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
                .disabled(viewModel.isLoading ? true : false)
                
                CenterView {
                    ProgressView("Đang tải")
                        .padding(30)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).opacity(0.8))
                        .tint(.white)
                        .foregroundStyle(.white)
                        .font(.headline)
                }
                .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
        .padding(.bottom, 80)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .destructive(Text("Đóng")))
        }
    }
}

struct CustomMyAccountHeaderView: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 30
    
    var title: String
    
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonWidth, alignment: .leading)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
                .padding(.leading, -buttonWidth)
                .padding(.bottom, 6)
            
            NavigationLink {
                ProtectionSystemScreen()
            } label: {
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonWidth, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 90, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: - PREVIEW
#Preview {
    MyAccount(viewModel: MyAccountViewModel(userInput: User(userId: 1, userName: "", fullName: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", email: "", imageUrl: "", identificationCard: "")))
}
