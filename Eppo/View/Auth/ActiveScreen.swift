//
//  ActiveScreen.swift
//  eppo
//
//  Created by Letter on 23/08/2024.
//

import SwiftUI

struct ActiveScreen: View {
    @State private var fullNameTextField: String = ""
    @State private var phoneNumberTextField: String = ""
    @State private var emailTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var confirmPasswordTextField: String = ""
    
    @State var viewModel = SignUpViewModel()
    
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: BODY
    var body: some View {
        VStack {
            CustomHeaderView(title: "Nhập thông tin")
            
            ScrollView(.vertical) {
                VStack(spacing: 24) {
                    Text("Xin lỗi vì sự bất tiện này! Nhưng chúng tôi cần bạn điền đầy đủ thông tin để tạo mới một tài khoản")
                        .foregroundStyle(.red)
                        .font(.system(size: 15, weight: .medium))
                        .multilineTextAlignment(.leading)
                        .fontDesign(.rounded)
                    
                    VStack(alignment: .leading) {
                        Text("Tên Đăng Nhập")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        BorderTextField {
                            TextField("Nguyễn Văn An", text: $viewModel.signUpUser.userName)
                        }
                        .frame(height: 50)
                        
                    } //: USERNAME STACK
                    
                    
                    VStack(alignment: .leading) {
                        Text("Mật khẩu")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        BorderTextField {
                            SecureField("❋❋❋❋❋❋❋❋", text: $viewModel.signUpUser.password)
                        }
                        .frame(height: 50)
                        
                    } //: PASSWORD STACK
                    
                    VStack(alignment: .leading) {
                        Text("Xác nhận mật khẩu")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        BorderTextField {
                            SecureField("❋❋❋❋❋❋❋❋", text: $viewModel.signUpUser.confirmPassword)
                        }
                        .frame(height: 50)
                    } //: CONFIRM PASSWORD STACK
                    
                    
                    VStack(alignment: .leading) {
                        Text("Họ Và Tên")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        BorderTextField {
                            TextField("Nguyễn Văn An", text: $viewModel.signUpUser.fullName)
                        }
                        .frame(height: 50)
                        
                    } //: FULLNAME STACK
                    
                    VStack(alignment: .leading) {
                        Text("Giới Tính")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        GenderSelector(selectedGender: $viewModel.signUpUser.gender)
                    } //: GENDER STACK
                    
                    VStack(alignment: .leading) {
                        Text("Loại tài khoản")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        RoleSelector(selectedRole: $viewModel.signUpUser.role)
                    } //: Loại tài khoản STACK
                    
                    VStack(alignment: .leading) {
                        Text("Ngày sinh")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        BorderTextField {
                            Text(viewModel.signUpUser.dateOfBirth, format: .dateTime.day().month().year())
                                .foregroundStyle(.gray)
                                .overlay {
                                    DatePicker(selection: $viewModel.signUpUser.dateOfBirth, displayedComponents: .date) {}
                                        .labelsHidden()
                                        .contentShape(Rectangle())
                                        .opacity(0.011)
                                }
                        }
                        .frame(height: 50)
                    } //: GENDER STACK
                    
                    VStack(alignment: .leading) {
                        Text("Số điện Thoại")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        
                        BorderTextField {
                            TextField("0912345678", text: $viewModel.signUpUser.phoneNumber)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                        
                    } //: PHONE NUMBER STACK
                    
                    VStack(alignment: .leading) {
                        Text("Địa chỉ Email")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        
                        BorderTextField {
                            TextField("abc123@gmail.com".lowercased(), text: $viewModel.signUpUser.email)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                    } //: EMAIL STACK
                    
                    VStack(alignment: .leading) {
                        Text("Địa chỉ")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        
                        BorderTextField {
                            TextField("84/2, Truong Tho, Ho Chi Minh", text: $viewModel.signUpUser.addressDescription)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                    } //: CCCD STACK
                    
                    VStack(alignment: .leading) {
                        Text("Số CCCD")
                            .foregroundColor(.textDarkBlue)
                            .font(.system(size: 17, weight: .medium))
                        
                        
                        BorderTextField {
                            TextField("0123456789".lowercased(), text: $viewModel.signUpUser.identificationCard)
                                .keyboardType(.numberPad)
                        }
                        .frame(height: 50)
                    } //: CCCD STACK
                    
                    Button {
                        viewModel.signUpAccount()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 60)
                                .foregroundStyle(
                                    LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                                )
                            
                            Text("Đăng ký")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .bold))
                        }
                        
                    } // ACTIVE BUTTON
                    .padding(.top, 30)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .padding(.horizontal)
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .default(Text("Đóng")))
        }
    }
}

#Preview {
    ActiveScreen()
}
