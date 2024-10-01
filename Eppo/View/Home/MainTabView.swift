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
    
    @State private var selectedTab: Tab = .cart
    
    init () {
//        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                AuctionScreen()
                    .tabItem {
                        Image(selectedTab == .auction ? "selected-auction" : "auction")
                        Text("Đấu giá")
                    }
                    .tag(Tab.auction)
                
                NotificationScreen()
                    .tabItem {
                        Label("Thông báo", systemImage: "bell")
                    }
                    .tag(Tab.notification)
                
                HomeScreen()
                    .tabItem {
                        Label("Khám phá", systemImage: "house")
                    }
                    .tag(Tab.explore)
                
                CartScreen()
                    .tabItem {
                        Label("Giỏ hàng", systemImage: "cart")
                    }
                    .tag(Tab.cart)
                
                ProfileScreen()
                    .tabItem {
                        Label("Tài khoản", systemImage: "person.fill")
                    }
                    .tag(Tab.profile)

            }
            .tint(.black)
//            .foregroundStyle(.black)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainTabView()
}
