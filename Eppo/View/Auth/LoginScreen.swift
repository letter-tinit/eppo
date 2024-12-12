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
    @State private var showAlert: Bool = false
    @State private var biometricImageName: String = "touchid"
    @State private var biometricType: String = "Touch ID"
    @State private var biometricAlertShowing: Bool = false

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
                                TextField("Tên đăng nhập", text: $viewModel.usernameTextField)
                            }
                            .frame(height: 50)
                            
                            Text("Mật Khẩu")
                                .foregroundStyle(.textDarkBlue)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.top, 30)
                            BorderTextField {
                                if viewModel.isShowingPassword {
                                    TextField("Mật khẩu", text: $viewModel.passwordTextField)
                                } else {
                                    SecureField("Mật khẩu", text: $viewModel.passwordTextField)
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
                            HStack(spacing: 0) {
                                Spacer()
                                
                                Button {
                                    if viewModel.usernameTextField.isEmpty || viewModel.passwordTextField.isEmpty {
                                        viewModel.errorMessage = "Tên đăng nhập và mật khẩu không được để trống."
                                        viewModel.isPopupMessage = true
                                    } else {
                                        viewModel.login(userName: viewModel.usernameTextField, password: viewModel.passwordTextField)
                                    }
                                } label: {
                                        Text("Đăng Nhập")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 16, weight: .bold))
                                            .frame(alignment: .center)
                                    
                                } // LOGIN BUTTON
                                
                                Spacer()
                                
                                Rectangle()
                                    .frame(width: 3)
                                    .foregroundStyle(.white)
                                
                                Button {
                                    enableBiometrics()
                                } label: {
                                    Image(systemName: biometricImageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .foregroundStyle(.white)
                                }
                                .frame(width: 60, alignment: .center)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
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
                .disabled(biometricAlertShowing)
                .blur(radius: viewModel.isLoading || biometricAlertShowing ? 1 : 0)
                
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
                
//                VStack(spacing: 10) {
//                    Image(systemName: biometricImageName)
//                        .font(.largeTitle)
//                        .foregroundStyle(.red)
//                    Text("\(biometricType) cho \"Eppo\"")
//                        .font(.headline)
//                    Text("Quí khách vui lonhg thực hiện")
//                    Text("A")
//                }
//                .frame(maxWidth: .infinity)
//                .frame(height: 200)
//                .padding()
//                .background(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .padding(40)
//                .opacity(0.95)
//                .shadow(radius: 1)
                
                VStack(spacing: 10) {
                    Image(systemName: "xmark.shield")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text("Có lỗi xảy ra")
                        .font(.headline)
                    Text("Tính năng xác thực sinh trắc chưa được kích hoạt")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                        .padding(.horizontal, -20)
                    HStack(spacing: 0) {
                        Button {
                            biometricAlertShowing = false
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            }
                        } label: {
                            Text("Cài đặt")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(.blue)
                        }
                        
                        Divider()
                            .padding(.vertical, -20)
                        
                        Button {
                            biometricAlertShowing = false
                        } label: {
                            Text("Huỷ")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundStyle(.red)
                                .fontWeight(.regular)
                        }
                    }
                    .frame(height: 36)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(40)
                .opacity(0.95)
                .shadow(radius: 1)
                .opacity(biometricAlertShowing ? 1 : 0)
                .animation(.bouncy(duration: 0.2), value: biometricAlertShowing)
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
            self.isSigned = true
            setUpBiometricType()
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
    
    func enableBiometrics() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication() {
            viewModel.loginWithBiometrics()
        } else {
            biometricAlertShowing = true
        }
    }
    
    func setUpBiometricType() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication() {
            // Biometric authentication is available, you can enable a switch or a button to let the user turn it on.
            switch BiometricAuthManager.shared.getBiometricType() {
            case .faceID:
                biometricImageName = "faceid"
                biometricType = "Face ID"
            case .touchID:
                biometricImageName = "touchid"
                biometricType = "Touch ID"
            case .opticID:
                biometricImageName = "opticid"
                biometricType = "Optic ID"
            default:
                biometricImageName = "gear.badge.xmark"
                biometricType = "Unknown"
            }
        } else {
            biometricImageName = "gear.badge.xmark"
            biometricType = "Unknown"
        }
    }
}

#Preview {
    LoginScreen()
}
