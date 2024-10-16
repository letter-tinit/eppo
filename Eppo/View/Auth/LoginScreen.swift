//
//  ContentView.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI

struct LoginScreen: View {
<<<<<<< Updated upstream
    @AppStorage("isLogged") var isLogged: Bool = false
    @State var viewModel = LoginViewModel()
=======
    @StateObject var viewModel = LoginViewModel()
>>>>>>> Stashed changes
    @State private var usernameTextField: String = ""
    @State private var passwordTextField: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        Rectangle()
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
<<<<<<< Updated upstream
                        VStack(alignment: .leading) {
                            Text("Tên Đăng Nhập")
                                .foregroundStyle(.textDarkBlue)
                                .font(.system(size: 16, weight: .semibold))
                            BorderTextField {
                                TextField("abc123@gmail.com".lowercased(), text: $usernameTextField)
=======
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
                        Button {
                            viewModel.login(userName: usernameTextField, password: passwordTextField)
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
>>>>>>> Stashed changes
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
                        
<<<<<<< Updated upstream
                        VStack(spacing: 30) {
                            Button {
                                if usernameTextField.isEmpty || passwordTextField.isEmpty {
                                    viewModel.errorMessage = "Tên đăng nhập và mật khẩu không được để trống."
                                } else {
                                    viewModel.login(userName: usernameTextField, password: passwordTextField)
=======
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
>>>>>>> Stashed changes
                                }
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
                                    
                                    
                                    HStack(spacing: 10) {
                                        Image("google-logo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 26, height: 26)
                                        
                                        Text("Google")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundStyle(Color(UIColor.darkGray))
                                    }
                                    .foregroundStyle(Color(UIColor.darkGray))
                                }
                            } // LOGIN WITH GOOGLE BUTTON
                            
                        }// LOGIN BUTTON STACK
                        .padding(.top, 40)
                    }// CONTENT
                    .padding(.horizontal, 20)
                    Spacer()
                    
                }
                .disabled(viewModel.isLoading)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.gray)
                    .opacity(viewModel.isLoading ? 0.05 : 0)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.white)
                        .opacity(0.6)
                    
                    ProgressView()
                        .controlSize(.large)
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .shadow(radius: 2, x: 1, y: 1)
                .opacity(viewModel.isLoading ? 1 : 0)
            }
            .ignoresSafeArea(.all)
            .alert(isPresented: $viewModel.isPopupMessage) {
                Alert(
                    title: Text("Lỗi"),
                    message: Text(viewModel.errorMessage ?? "Lỗi không xác định"),
                    dismissButton: .default(Text("Xác nhận"), action: {
                        viewModel.errorMessage = nil
                    })
                )
            }
            .navigationDestination(isPresented: $viewModel.isLogged) {
                MainTabView()
            }
        }
        .onChange(of: viewModel.isLogged) {
            isLogged = true
        }
    }
}

#Preview {
    LoginScreen()
}
