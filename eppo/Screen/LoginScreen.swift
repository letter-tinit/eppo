//
//  ContentView.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI

struct LoginScreen: View {
    @State private var usernameTextField: String = ""
    @State private var passwordTextField: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 100)
                        .foregroundStyle(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        )
                    
                    VStack {
                        Text("Đăng Nhập EPPO")
                            .padding(.top)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Tên Đăng Nhập")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                        BorderTextField {
                            TextField("abc123@gmail.com".lowercased(), text: $usernameTextField)
                        }
                        .frame(height: 50)
                        
                        Text("Mật Khẩu")
                            .foregroundStyle(.textDarkBlue)
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.top, 30)
                        BorderTextField {
                            SecureField("Mật khẩu", text: $passwordTextField)
                        }
                        .frame(height: 50)
                        
                    } // TEXT FIELD STACK
                    .padding(.top, 80)
                    
                    VStack(spacing: 30) {
                        NavigationLink {
                            ActiveScreen()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 60)
                                    .foregroundStyle(
                                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                                    )
                                
                                Text("Đăng Nhập")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                        } // LOGIN BUTTON
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 0)
                                .frame(width: 100, height: 1)
                            
                            Text("Hoặc tiếp tục với")
                                .font(.system(size: 14))
                            
                            RoundedRectangle(cornerRadius: 0)
                                .frame(width: 100, height: 1)
                        } //DIVIDER STACK
                        .foregroundStyle(Color(UIColor.darkGray))
                        
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 1)
                                    .frame(height: 60)
                                
                                
                                HStack {
                                    Image("google-logo")
                                    
                                    Text("Google")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(Color(UIColor.darkGray))
                                }
                                .foregroundStyle(Color(UIColor.darkGray))
                            }
                            
                        } // LOGIN WITH GOOGLE BUTTON
                        
                    }// LOGIN BUTTON STACK
                    .padding(.top, 40)
                    
                    //                HStack(spacing: 6) {
                    //                    Text("Chưa có tài khoản?")
                    //                        .foregroundStyle(.gray)
                    //                        .font(.system(size: 16, weight: .semibold))
                    //
                    //                    Button {
                    //
                    //                    } label: {
                    //                        Text("Đăng Ký")
                    //                            .foregroundStyle(.textDarkBlue)
                    //                            .font(.system(size: 16, weight: .semibold))
                    //                    }
                    //                }
                    //                .padding(.top, 30)
                    
                }// CONTENT
                .padding(.horizontal, 20)
                Spacer()
                
            }
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    LoginScreen()
}
