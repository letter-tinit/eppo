//
//  MainTabView.swift
//  Eppo
//
//  Created by Letter on 05/09/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case auction
    case notification
    case explore
    case cart
    case profile
}

struct MainTabView: View {
    // MARK: - PROPERTY
    @State var selectedTab: Tab
    @State var viewModel = LoginViewModel()
    
    init (selectedTab: Tab) {
        //        UITabBar.appearance().backgroundColor = UIColor.white
        
        self.selectedTab = selectedTab
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .tabItem {
                        Label("Tìm cây", systemImage: "house")
                    }
                    .tag(Tab.explore)
                
                NotificationScreen()
                    .tabItem {
                        Label("Thông báo", systemImage: "bell")
                    }
                    .tag(Tab.notification)
                
                AuctionScreen()
                    .tabItem {
                        Image(selectedTab == .auction ? "selected-auction" : "auction")
                        Text("Đấu giá")
                    }
                    .tag(Tab.auction)
                
                CartScreen()
                    .tabItem {
                        Label("Giỏ hàng", systemImage: "cart")
                    }
                    .tag(Tab.cart)
                    .badge(UserSession.shared.cart.count + UserSession.shared.hireCart.count)

                ProfileScreen()
                    .tabItem {
                        Label("Tài khoản", systemImage: "person.fill")
                    }
                    .tag(Tab.profile)
            }
            .tint(.black)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getMyInformation()
        }
    }
}

#Preview {
    MainTabView(selectedTab: .explore)
}
