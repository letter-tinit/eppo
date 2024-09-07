//
//  MainTabView.swift
//  Eppo
//
//  Created by Letter on 05/09/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case auction
    case chat
    case explore
    case profile
    case notification
}

struct MainTabView: View {
    // MARK: - PROPERTY
    
    @State private var selectedTab: Tab = .explore
    
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $selectedTab) {
            AuctionScreen()
                .tabItem {
                    Image(selectedTab == .profile ? "selected-auction" : "auction")
                    Text("Đấu giá")
                }
                .tag(Tab.profile)
            
            ProfileScreen()
                .tabItem {
                    Label("Tin nhắn", systemImage: "ellipsis.message")
                }
                .tag(Tab.chat)
            
            HomeScreen()
                .tabItem {
                    Label("Khám phá", systemImage: "house")
                }
                .tag(Tab.explore)
            
            ProfileScreen()
                .tabItem {
                    Label("Thông báo", systemImage: "bell")
                }
                .tag(Tab.notification)
            
            ProfileScreen()
                .tabItem {
                    Label("Tài khoản", systemImage: "person.fill")
                }
                .tag(Tab.profile)

        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
