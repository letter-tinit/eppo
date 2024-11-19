//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerProfileScreen: View {
    // MARK: - PROPERTY
    @AppStorage("isLogged") var isLogged: Bool = false
    
    @State private var isActiveWaitingForConfirmed = false
    @State private var isActiveWaitingForPackage = false
    @State private var isActiveWaitingForDelivered = false
    @State private var isActiveRating = false
    
    @State var selectedOrderState: OrderState = .delivered
    // MARK: - BODY
    
    var body: some View {
//        NavigationStack {
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
                        OwnerBalanceBox(balance: "10.000.000")
                    }
                    .padding(.top, 20)
                    
                    
                    // MARK: - DELIVER TOOLS BAR
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.settingBoxBackground)
                        
                        HStack(spacing: 24) {
                            Button {
                                isActiveWaitingForConfirmed = true
                                selectedOrderState = .waitingForConfirm
                            } label: {
                                OwnerCustomButtomImageLabel(imageName: "doc.append.fill", title: "Hợp đồng")
                            }
//                            .navigationDestination(isPresented: $isActiveWaitingForConfirmed) {
//                                OrderHistoryScreen(selectedOrderState: $selectedOrderState)
//                            }
                            
                            Button {
                                isActiveWaitingForPackage = true
                                selectedOrderState = .waitingForPackage
                            } label: {
                                OwnerCustomButtomImageLabel(imageName: "creditcard.fill", title: "Nạp tiền")
                            }
//                            .navigationDestination(isPresented: $isActiveWaitingForPackage) {
//                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
//                            }
                            
                            Button {
                                isActiveWaitingForDelivered = true
                                selectedOrderState = .waitingForDeliver
                            } label: {
                                OwnerCustomButtomImageLabel(imageName: "dollarsign.square.fill", title: "Rút tiền")
                            }
//                            .navigationDestination(isPresented: $isActiveWaitingForDelivered) {
//                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
//                            }
                            
                            Button {
                                isActiveRating = true
                                selectedOrderState = .waitingForDeliver
                            } label: {
                                OwnerCustomButtomImageLabel(imageName: "star.bubble.fill", title: "Đánh giá")
                            }
//                            .navigationDestination(isPresented: $isActiveRating) {
//                                OrderHistoryScreen(selectedOrderState:$selectedOrderState)
//                            }
                        }
                    }
                    .frame(height: 90)
                    .padding(.top)
                    
                    // MARK: - CONTENT STACK
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.settingBoxBackground)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            CustomSettingNavigationLink(image: "person", title: "Tài khoản của tôi", destination: MyAccount(viewModel: ProfileViewModel()))
                            
                            Divider()
                            
                            CustomSettingNavigationLink(image: "doc.badge.clock", title: "Lịch sử giao dịch", destination: TransactionHistoryScreen(viewModel: ProfileViewModel()))
                            
                            Divider()
                            
                            CustomSettingNavigationLink(image: "creditcard", title: "Thông tin thanh toán", destination: Text("Destination View"))
                            
                            Divider()
                            
                            CustomSettingNavigationLink(image: "questionmark.bubble", title: "Hỗ trợ", destination: Text("Destination View"))
                        }
                    }
                    .frame(height: 280)
                    
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
//        }
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerProfileScreen()
}
