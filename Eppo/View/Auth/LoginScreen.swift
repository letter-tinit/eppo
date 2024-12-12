//
//  ContentView.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI

struct LoginScreen: View {
    @AppStorage("isLogged") var isLogged: Bool = false
    @AppStorage("isCustomer") var isCustomer: Bool = false
    @AppStorage("isOwner") var isOwner: Bool = false
    @AppStorage("isSigned") var isSigned: Bool = true
    @State var viewModel = LoginViewModel()
    @State var protectionViewModel = ProtectionSystemViewModel()
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
                                .padding(.top, 44)
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
                                TextField("Tên đăng nhập", text: $usernameTextField)
                            }
                            .frame(height: 50)
                            
                            Text("Mật Khẩu")
                                .foregroundStyle(.textDarkBlue)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 30)
                            BorderTextField {
                                if viewModel.isShowingPassword {
                                    TextField("Mật khẩu", text: $passwordTextField)
                                } else {
                                    SecureField("Mật khẩu", text: $passwordTextField)
                                }
                            }
                            .frame(height: 50)
                            .overlay(alignment: .trailing) {
                                Button {
                                    viewModel.isShowingPassword.toggle()
                                } label: {
                                    Image(systemName: viewModel.isShowingPassword ? "eye" : "eye.slash")
                                        .foregroundStyle(viewModel.isShowingPassword ? .black : .gray)
                                        .padding(.trailing)
                                }
                            }
                            
                        } // TEXT FIELD STACK
                        .padding(.top, 80)
                        
                        Button {
                            protectionViewModel.isShowingPopover = true
                        } label: {
                            Text("Quên mật khẩu?")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .popover(isPresented: $protectionViewModel.isShowingPopover, arrowEdge: .bottom) {
                            VStack(alignment: .leading) {
                                Text("Chúng tôi sẽ gửi mật khẩu mới đến email này nếu email hợp lệ")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                                
                                BorderTextField {
                                    TextField("Địa chỉ email", text: $protectionViewModel.email)
                                }
                                .frame(height: 40)
                                .presentationCompactAdaptation(.popover)
                                
                                Spacer()
                                
                                Button {
                                    protectionViewModel.isShowingPopover = false
                                } label: {
                                    Text("Gửi")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }
                            .frame(width: 260, height: 180)
                            .background()
                            .padding(.vertical, 60)
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 30) {
                            Button {
                                if usernameTextField.isEmpty || passwordTextField.isEmpty {
                                    viewModel.errorMessage = "Tên đăng nhập và mật khẩu không được để trống."
                                    viewModel.isPopupMessage = true
                                } else {
                                    viewModel.login(userName: usernameTextField, password: passwordTextField)
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
                            
                            //                            HStack {
                            //                                RoundedRectangle(cornerRadius: 0)
                            //                                    .frame(width: 100, height: 1)
                            //
                            //                                Text("Hoặc tiếp tục với")
                            //                                    .font(.system(size: 14))
                            //
                            //                                RoundedRectangle(cornerRadius: 0)
                            //                                    .frame(width: 100, height: 1)
                            //                            } //DIVIDER STACK
                            //                            .foregroundStyle(Color(UIColor.darkGray))
                            //
                            //                            Button {
                            //
                            //                            } label: {
                            //                                ZStack {
                            //                                    RoundedRectangle(cornerRadius: 10)
                            //                                        .stroke(.black, lineWidth: 1)
                            //                                        .frame(height: 60)
                            //
                            //
                            //                                    HStack(spacing: 10) {
                            //                                        Image("google-logo")
                            //                                            .resizable()
                            //                                            .scaledToFit()
                            //                                            .frame(width: 26, height: 26)
                            //
                            //                                        Text("Google")
                            //                                            .font(.system(size: 16, weight: .bold))
                            //                                            .foregroundStyle(Color(UIColor.darkGray))
                            //                                    }
                            //                                    .foregroundStyle(Color(UIColor.darkGray))
                            //                                }
                            //                            } // LOGIN WITH GOOGLE BUTTON
                            
                        }// LOGIN BUTTON STACK
                        .padding(.top, 40)
                    }// CONTENT
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 6) {
                        Text("Chưa có tài khoản?")
                            .foregroundStyle(.gray)
                            .font(.system(size: 16, weight: .semibold))
                        
                        NavigationLink {
                            ActiveScreen()
                        } label: {
                            Text("Đăng Ký")
                                .foregroundStyle(.textDarkBlue)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .padding(.top, 30)
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
            .ignoresSafeArea(.container, edges: .vertical)
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
                MainTabView(selectedTab: .explore)
            }
        }
        .onAppear {
            //            viewModel.login(userName: "customer", password: "123")
            self.isSigned = true
        }
        .onChange(of: viewModel.isCustomer) { oldValue, newValue in
            self.isCustomer = newValue
            if newValue { self.isOwner = false } // Đảm bảo không trùng trạng thái
        }
        .onChange(of: viewModel.isOwner) { oldValue, newValue in
            self.isOwner = newValue
            if newValue { self.isCustomer = false } // Đảm bảo không trùng trạng thái
        }
        .onChange(of: viewModel.isLogged) { _, newValue in
            self.isLogged = newValue
        }
        .onChange(of: viewModel.isSigned) { oldValue, newValue in
            self.isSigned = newValue
        }
    }
}

#Preview {
    LoginScreen()
}
