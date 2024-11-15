//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ProfileScreen: View {
    // MARK: - PROPERTY
    @AppStorage("isLogged") var isLogged: Bool = false
    
    @State var viewModel = ProfileViewModel()
    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            VStack {
                // MARK: - HEADER STACK
                VStack(alignment: .center, spacing: 10) {
                    CircleImageView(image: Image("avatar"), size: 140)
                    
                    Text(viewModel.userResponse?.data.fullName ?? "Đang tải")
                        .font(.system(size: 22, weight: .medium))
                    
                    Text(viewModel.userResponse?.data.email ?? "Đang tải")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.gray)
                    
                } //: HEADER STACK
                
                if let wallet = viewModel.userResponse?.data.wallet {
                    BalanceBox(balance: wallet.numberBalance)
                } else {
                    BalanceBox(balance: 0)
                }
                
                
                // MARK: - DELIVER TOOLS BAR
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.settingBoxBackground)
                    
                    HStack(spacing: 14) {
                        NavigationLink {
                            OrderHistoryScreen()
                        } label: {
                            CustomButtonImageLabel(imageName: "cart.badge.plus", title: "Đơn mua")
                        }
                        
                        NavigationLink {
                            HireOrderHistoryScreen()
                        } label: {
                            CustomButtonImageLabel(imageName: "doc.plaintext", title: " Đơn thuê")
                        }
                        
                        Button {
                        } label: {
                            CustomButtonImageLabel(imageName: "truck.box.badge.clock.fill", title: "Chờ giao hàng")
                        }
                        
                        Button {
                        } label: {
                            CustomButtonImageLabel(imageName: "star.bubble.fill", title: "Đánh giá")
                        }
                    }
                }
                .frame(height: 90)
                .padding(.top)
                
                // MARK: - CONTENT STACK
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.settingBoxBackground)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        CustomSettingNavigationLink(image: "person", title: "Tài khoản của tôi", destination: MyAccount(viewModel: viewModel))
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "message", title: "Nhắn tin với quản trị", destination: ChatScreen())
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "clock", title: "Lịch sử đấu giá", destination: Text("Destination View"))
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "doc.badge.clock", title: "Lịch sử giao dịch", destination: TransactionHistoryScreen())
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "creditcard", title: "Thông tin thanh toán", destination: Text("Destination View"))
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "questionmark.bubble", title: "Hỗ trợ", destination: Text("Destination View"))
                    }
                }
                .frame(height: 360)
                
                Spacer(minLength: 80)
                
                Button {
                    viewModel.logout()
                    self.isLogged = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundStyle(
                                LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                            )
                        
                        Text("Đăng Xuất")
                            .foregroundStyle(.black)
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                } // LOGOUT BUTTON
                
                Spacer(minLength: 30)
                
                Text("version 1.0.0")
                    .foregroundStyle(.secondary)
                
                Spacer(minLength: 20)
                
            }
            .padding(.horizontal, 10)
        }// Scroll View
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.getMyInformation()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ProfileScreen()
}
