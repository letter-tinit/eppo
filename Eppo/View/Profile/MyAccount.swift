//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

enum Gender {
    case male
    case female
}



struct MyAccount: View {
    // MARK: - PROPERTY
    @State private var usernameTextField: String = ""
    @State private var phoneNumberTextField: String = ""
    @State private var emailTextField: String = ""
    @State private var addressTextField: String = ""
    @State private var idCodeTextField: String = ""
    
    @State private var date = Date()
    
    @State private var selectedGender: Gender = .male
    
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
                        Text("Tên Đăng Nhập")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField("Nguyễn Văn An", text: $usernameTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Giới Tính")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        HStack(spacing: 80) {
                            GenderRadioButton(title: "Nam", isSelected: .constant(selectedGender == .male))
                                .onTapGesture {
                                    selectedGender = .male
                                }
                            
                            GenderRadioButton(title: "Nữ", isSelected: .constant(selectedGender == .female))
                                .onTapGesture {
                                    selectedGender = .female
                                }
                        }
                        
                        Text("Số Điện Thoại")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField("0912345678", text: $phoneNumberTextField)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                        
                        Text("Ngày Sinh")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        
                        BorderTextField {
                            Text("01/01/2000")
                                .foregroundStyle(.gray)
                                .overlay {
                                    DatePicker(selection: $date, displayedComponents: .date) {}
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
                            TextField("abc123@gmail.com".lowercased(), text: $emailTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Địa Chỉ")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField("abc123, quận 9, TP. Hồ Chí Minh", text: $addressTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Số CCCD")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField("0000000000", text: $idCodeTextField)
                        }
                        .frame(height: 50)
                        
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
    MyAccount()
}
