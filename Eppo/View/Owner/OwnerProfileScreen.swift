//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerProfileScreen: View {
    // MARK: - PROPERTY
    @AppStorage("isLogged") var isLogged: Bool = false
    @State var viewModel = OwnerProfileViewModel()
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    var appBuild: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
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
                
                HStack(spacing: 20) {
                    OwnerBalanceBox(balance: viewModel.user.wallet?.numberBalance ?? 0)
                }
                .padding(.top, 20)
            }
            
            // MARK: - CONTENT STACK
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.settingBoxBackground)
                
                VStack(alignment: .leading, spacing: 20) {
                    CustomSettingNavigationLink(
                        image: "person",
                        title: "Tài khoản của tôi",
                        destination: MyAccount(
                            viewModel: MyAccountViewModel(userInput: viewModel.user)
                        )
                    )
                    
                    Divider()
                    
                    CustomSettingNavigationLink(image: "doc.badge.clock", title: "Lịch sử giao dịch", destination: TransactionHistoryScreen(viewModel: ProfileViewModel()))
                    
                    Divider()
                    
                    CustomSettingNavigationLink(image: "doc.append", title: "Hợp đồng", destination: ReviewOwnerContractScreen())
                    
                    Divider()
                    
                    CustomSettingNavigationLink(image: "creditcard", title: "Rút tiền", destination: CashOutScreen())
                    
                    Divider()
                    
                    CustomSettingNavigationLink(image: "questionmark.bubble", title: "Hỗ trợ", destination: Text("Destination View"))
                }
            }
            .frame(height: 320)
            .padding(.top)
            
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
            
            Text("v\(appVersion).\(appBuild)")
                .foregroundStyle(.secondary)
            
            Spacer(minLength: 20)
            
        }// Scroll View
        .padding(.horizontal, 10)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.getMyInformation()
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerProfileScreen()
}
