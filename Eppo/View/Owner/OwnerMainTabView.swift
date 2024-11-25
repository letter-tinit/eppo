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
    @State private var selectedTab: OwnerTab = .addition
    @State var viewModel = LoginViewModel()
    
    init () {
        //        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    // MARK: - BODY
    var body: some View {
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
                
                OwnerProfileScreen()
                    .tabItem {
                        Label("Tài khoản", systemImage: "person.fill")
                    }
                    .tag(OwnerTab.profile)
            }
        }
        .tint(.black)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getMyInformation()
            print(UserSession.shared.token as Any)
        }
    }
}


#Preview {
    OwnerMainTabView()
}
