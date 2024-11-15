//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

enum Gender {
    case male
    case female
    
    var isFemale: Bool {
        self == .female
    }
}

struct MyAccount: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ProfileViewModel
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Tài Khoản Của Tôi")
            
            ScrollView(.vertical) {
                VStack {
                    CircleImageView(image: Image("avatar"), size: 100)
                        .padding(.top)
                        .overlay(alignment: .bottomTrailing) {
                            EditAvatarButton {
                                print("Action")
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tên Đầy Đủ")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userResponse?.data.fullName ?? "Đang tải", text: $viewModel.usernameTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Giới Tính")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        HStack(spacing: 80) {
                            GenderRadioButton(title: "Nam", isSelected: $viewModel.isMale)
                                .onTapGesture {
                                    viewModel.setIsMale(true)
                                }
                            
                            GenderRadioButton(title: "Nữ", isSelected: $viewModel.isFemale)
                                .onTapGesture {
                                    viewModel.setIsMale(false)
                                }
                        }
                        
                        Text("Số Điện Thoại")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userResponse?.data.phoneNumber ?? "Đang tải", text: $viewModel.phoneNumberTextField)
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
                            Text(viewModel.isSelectedDate ? viewModel.selectedDate() : viewModel.dayOfBirth() ?? "Đang Tải")
                                .foregroundStyle(.gray)
                                .overlay {
                                    DatePicker(selection: $viewModel.date, displayedComponents: .date) {}
                                        .labelsHidden()
                                        .contentShape(Rectangle())
                                        .opacity(0.011)
                                        .onChange(of: viewModel.date) {
                                            viewModel.isSelectedDate = true
                                        }
                                }
                        }
                        .frame(height: 50)
                        
                        Text("Email")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(viewModel.userResponse?.data.email ?? "Đang tải", text: $viewModel.emailTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Số CCCD")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField(text: $viewModel.idCodeTextField) {
                                Text(viewModel.userResponse?.data.identificationCard ?? 0, format: .number.grouping(.never))
                                
                            }
                            .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                        
                        NavigationLink {
                            AddressScreen(viewModel: viewModel)
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
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 60)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                                    )
                                
                                Text("Lưu")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                        } // SAVE BUTTON
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal)
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
    }
}

// MARK: - PREVIEW
#Preview {
    MyAccount(viewModel: ProfileViewModel())
}
