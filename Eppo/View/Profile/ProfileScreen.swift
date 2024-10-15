//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ProfileScreen: View {
    // MARK: - PROPERTY
    @AppStorage("isLogged") var isLogged: Bool = false
    
    @State private var isActiveWaitingForConfirmed = false
    @State private var isActiveWaitingForPackage = false
    @State private var isActiveWaitingForDelivered = false
    @State private var isActiveRating = false

    @State var selectedOrderState: OrderState = .delivered
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // MARK: - HEADER STACK
                    VStack(alignment: .center, spacing: 10) {
                        CircleImageView(image: Image("avatar"), size: 140)
                        
                        Text("Nguyễn Văn An")
                            .font(.system(size: 22, weight: .medium))
                        
                        Text("abc123@gmail.com".lowercased())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray)
                        
                    } //: HEADER STACK
                    HStack(spacing: 20) {
                        BalanceBox(balance: "10.000.000")
                        
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.settingBoxBackground)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("EPPO")
                                
                                Text("Hạng Vàng")
                                    .foregroundStyle(.yellow)
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .padding()
                        }
                        .frame(height: 100)
                    }
                    .padding(.top, 20)
                    
                    
                    // MARK: - DELIVER TOOLS BAR
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.settingBoxBackground)
                        
                        HStack(spacing: 14) {
                            Button {
                                isActiveWaitingForConfirmed = true
                                selectedOrderState = .waitingForConfirm
                            } label: {
                                CustomButtonImageLabel(imageName: "list.clipboard.fill", title: "Chờ xác nhận")
                            }
                            .navigationDestination(isPresented: $isActiveWaitingForConfirmed) {
                                OrderHistoryScreen(selectedOrderState: $selectedOrderState)
                            }
                            
                            Button {
                                isActiveWaitingForPackage = true
                                selectedOrderState = .waitingForPackage
                            } label: {
                                CustomButtonImageLabel(imageName: "clock.arrow.circlepath", title: "Chờ đóng gói")
                            }
                            .navigationDestination(isPresented: $isActiveWaitingForPackage) {
                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
                            }

                            Button {
                                isActiveWaitingForDelivered = true
                                selectedOrderState = .waitingForDeliver
                            } label: {
                                CustomButtonImageLabel(imageName: "truck.box.badge.clock.fill", title: "Chờ giao hàng")
                            }
                            .navigationDestination(isPresented: $isActiveWaitingForDelivered) {
                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
                            }
                            
                            Button {
                                isActiveRating = true
                                selectedOrderState = .waitingForDeliver
                            } label: {
                                CustomButtonImageLabel(imageName: "star.bubble.fill", title: "Đánh giá")
                            }
                            .navigationDestination(isPresented: $isActiveRating) {
                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
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
                            CustomSettingNavigationLink(image: "person", title: "Tài khoản của tôi", destination: MyAccount())
                            
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
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ProfileScreen()
}
