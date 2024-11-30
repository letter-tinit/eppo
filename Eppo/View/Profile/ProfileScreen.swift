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
                    CustomCircleAsyncImage(imageUrl: viewModel.user.imageUrl, size: 140)
                    
                    Text(viewModel.user.fullName)
                        .font(.system(size: 22, weight: .medium))
                    
                    Text(viewModel.user.email)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.gray)
                    
                } //: HEADER STACK
                
                BalanceBox(balance: viewModel.user.wallet?.numberBalance ?? 0)
                
                
                // MARK: - DELIVER TOOLS BAR
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.settingBoxBackground)
                    
                    HStack(spacing: 20) {
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
                        
                        NavigationLink {
                            ChatScreen()
                        } label: {
                            CustomButtonImageLabel(imageName: "message", title: "Nhắn tin")
                        }
                        
                        NavigationLink {
                            FeedBackScreen()
                        } label: {
                            CustomButtonImageLabel(imageName: "star.bubble", title: "Đánh giá")
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

                        CustomSettingNavigationLink(image: "person", title: "Tài khoản của tôi", destination: MyAccount(viewModel: MyAccountViewModel(userInput: viewModel.user)))
                        
                        Divider()
                        
//                        CustomSettingNavigationLink(image: "message", title: "Nhắn tin với quản trị", destination: ChatScreen())
                        
//                        Divider()
                        
                        CustomSettingNavigationLink(image: "clock", title: "Lịch sử đấu giá", destination: Text("Destination View"))
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "doc.badge.clock", title: "Lịch sử giao dịch", destination: TransactionHistoryScreen(viewModel: viewModel))
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "creditcard", title: "Thông tin thanh toán", destination: PaymentScreen())
                        
                        Divider()
                        
                        CustomSettingNavigationLink(image: "questionmark.bubble", title: "Hỗ trợ", destination: Text("Destination View"))
                    }
                }
                .frame(height: 330)
                
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
        .redacted(reason: self.viewModel.isLoading ? .placeholder : .privacy)
        .disabled(self.viewModel.isLoading)
    }
}

// MARK: - PREVIEW
#Preview {
    ProfileScreen()
}
