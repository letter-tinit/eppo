//
//  OwnerMainTabView.swift
//  Eppo
//
//  Created by Letter on 23/10/2024.
//

import SwiftUI

enum OwnerTab: String, CaseIterable {
    case addition
    case notification
    case home
    case message
    case profile
}

struct OwnerMainTabView: View {
    // MARK: - PROPERTY
    @AppStorage("isOwnerChatting") var isOwnerChatting: Bool = false
    
    @State private var selectedTab: OwnerTab = .addition
    
    init () {
        //        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    // MARK: - BODY
    var body: some View {
        if !isOwnerChatting {
            NavigationStack {
                TabView(selection: $selectedTab) {
                    OwnerItemAdditionScreen()
                        .tabItem {
                            Label("Thêm", systemImage: "plus.circle")
                        }
                        .tag(OwnerTab.addition)
                    
                    NotificationScreen()
                        .tabItem {
                            Label("Thông báo", systemImage: "bell")
                        }
                        .tag(OwnerTab.notification)
                    
                    OwnerHome()
                        .tabItem {
                            Label("Trang Chủ", systemImage: "house")
                        }
                        .tag(OwnerTab.home)
                    
                    OwnerChatScreen()
                        .tabItem {
                            Label("Nhắn tin", systemImage: "message")
                        }
                        .tag(OwnerTab.message)
                    
                    OwnerProfileScreen()
                        .tabItem {
                            Label("Tài khoản", systemImage: "person.fill")
                        }
                        .tag(OwnerTab.profile)
                }
                .tint(.black)
                .onChange(of: selectedTab) { oldTab, newTab in
                    if newTab == .message {
                        isOwnerChatting = true
                        selectedTab = oldTab
                    }
                }
            }
            .navigationBarBackButtonHidden()
        } else {
            OwnerChatScreen()
        }
    }
}

#Preview {
    OwnerMainTabView()
}
