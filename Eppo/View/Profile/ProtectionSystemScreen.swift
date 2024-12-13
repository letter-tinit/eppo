//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ProtectionSystemScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel = ProtectionSystemViewModel()

    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomHeaderView(title: "Đổi mật khẩu")
            VStack(alignment: .leading, spacing: 20) {
                Text("Mật khẩu cũ")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                BorderTextField {
                    if viewModel.isShowingPassword {
                        TextField("Mật khẩu cũ", text: $viewModel.oldPassword)
                    } else {
                        SecureField("Mật khẩu cũ", text: $viewModel.oldPassword)
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
                
                Text("Mật khẩu mới")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                BorderTextField {
                    TextField(text: $viewModel.newPassword) {
                        Text("Mật khẩu mới")
                    }
                }
                .frame(height: 50)
                
                Button {
                    viewModel.isShowingPopover = true
                } label: {
                    Text("Quên mật khẩu?")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .popover(isPresented: $viewModel.isShowingPopover, arrowEdge: .bottom) {
                    VStack(alignment: .leading) {
                        Text("Chúng tôi sẽ gửi mật khẩu mới đến email này nếu email hợp lệ")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                        
                        BorderTextField {
                            TextField("Địa chỉ email", text: $viewModel.email)
                        }
                        .frame(height: 40)
                        .presentationCompactAdaptation(.popover)
                        
                        Spacer()
                        
                        Button {
                            forgetPassword()
                            viewModel.isShowingPopover = false
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
                
                Button {
                    viewModel.changePassword()
                } label: {
                    Text("Xác nhận")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 30)
                }
                
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .top )
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.activeAlert {
            case .remind:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? ""), dismissButton: .cancel())
            case .error:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? ""), dismissButton: .cancel())
            case .success:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? ""), dismissButton: .cancel())
            }
        }
    }
    
    private func forgetPassword() {
        viewModel.forgetPassword { completion in
            switch completion {
            case .success(let message):
                viewModel.activeAlert = .success
                viewModel.message = message
                viewModel.isShowingAlert = true
            case .failure(let error):
                viewModel.activeAlert = .error
                viewModel.message = error.localizedDescription
                viewModel.isShowingAlert = true
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ProtectionSystemScreen()
}
