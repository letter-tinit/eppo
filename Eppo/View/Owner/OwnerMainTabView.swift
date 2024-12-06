//
//  OwnerMainTabView.swift
//  Eppo
//
//  Created by Letter on 23/10/2024.
//

import SwiftUI

enum OwnerTab: String, CaseIterable {
    case waitingPlant
    case notification
    case home
    case order
    case profile
}

struct OwnerMainTabView: View {
    // MARK: - PROPERTY
    @State private var selectedTab: OwnerTab = .home
    @State var viewModel = LoginViewModel()
    
    init () {
        //        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                OwnerHome()
                    .tabItem {
                        Label("Cây", systemImage: "tree.fill")
                    }
                    .tag(OwnerTab.home)
                
                OwnerWaitingPlantScreen()
                    .tabItem {
                        Label("Chờ duyệt", systemImage: "person.badge.clock")
                    }
                    .tag(OwnerTab.waitingPlant)
                
                NotificationScreen()
                    .tabItem {
                        Label("Thông báo", systemImage: "bell")
                    }
                    .tag(OwnerTab.notification)
                
                OwnerOrderScreen()
                    .tabItem {
                        Spacer(minLength: 20)
                        Label("Đơn hàng", systemImage: "list.clipboard.fill")
                    }
                    .tag(OwnerTab.order)
                               
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
            
            // MARK: - THIS CONFIGURATION MAKE TABBAR NOT HIDDEN WHEN CONTENT IS TOO SHORT
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}


#Preview {
    OwnerMainTabView()
}
