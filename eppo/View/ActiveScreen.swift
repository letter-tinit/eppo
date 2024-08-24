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
    
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: BODY
    var body: some View {
        VStack(spacing: 22) {
            VStack(spacing: 10) {
                Text("Bắt Đầu nào!")
                    .foregroundStyle(.textDarkBlue)
                    .font(.system(size: 32, weight: .bold))
                
                Text("Điền đầy đủ thông tin để tạo mới một tài khoản")
                    .foregroundStyle(.gray)
                    .font(.system(size: 15, weight: .medium))
            }//: TITLE STACK
            
            VStack(alignment: .leading) {
                Text("Họ Và Tên")
                    .foregroundColor(.textDarkBlue)
                    .font(.system(size: 17, weight: .medium))
                
                BorderTextField {
                    TextField("Nguyễn Văn An", text: $fullNameTextField)
                }
                .frame(height: 50)
                
            } //: FULLNAME STACK
            
            VStack(alignment: .leading) {
                Text("Số điện Thoại")
                    .foregroundColor(.textDarkBlue)
                    .font(.system(size: 17, weight: .medium))
                
                
                BorderTextField {
                    TextField("0912345678", text: $phoneNumberTextField)
                        .keyboardType(.numberPad)
                }
                .frame(height: 50)
                
            } //: PHONE NUMBER STACK
            
            VStack(alignment: .leading) {
                Text("Địa chỉ Email")
                    .foregroundColor(.textDarkBlue)
                    .font(.system(size: 17, weight: .medium))
                
                
                BorderTextField {
                    TextField("abc123@gmail.com".lowercased(), text: $emailTextField)
                        .keyboardType(.numberPad)
                }
                .frame(height: 50)
            } //: EMAIL STACK
            
            VStack(alignment: .leading) {
                Text("Mật khẩu")
                    .foregroundColor(.textDarkBlue)
                    .font(.system(size: 17, weight: .medium))
                
                BorderTextField {
                    SecureField("❋❋❋❋❋❋❋❋", text: $passwordTextField)
                }
                .frame(height: 50)
                
            } //: PASSWORD STACK
            
            VStack(alignment: .leading) {
                Text("Xác nhận mật khẩu")
                    .foregroundColor(.textDarkBlue)
                    .font(.system(size: 17, weight: .medium))
                
                BorderTextField {
                    SecureField("❋❋❋❋❋❋❋❋", text: $confirmPasswordTextField)
                }
                .frame(height: 50)
            } //: CONFIRM PASSWORD STACK
            
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 60)
                        .foregroundStyle(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    Text("Kích hoạt")
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .bold))
                }
                
            } // ACTIVE BUTTON
            .padding(.top, 30)
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    ActiveScreen()
}
