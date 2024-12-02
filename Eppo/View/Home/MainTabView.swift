//
//  MainTabView.swift
//  Eppo
//
//  Created by Letter on 05/09/2024.
//

import SwiftUI
import UserNotifications

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
    let notificationCenter = UNUserNotificationCenter.current()
    
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
                        Label("Tìm cây", systemImage: "tree.fill")
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
                    .badge(UserSession.shared.cart.count)

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
            requestNotification()
            addNotification()
            
            // MARK: - THIS CONFIGURATION MAKE TABBAR NOT HIDDEN WHEN CONTENT IS TOO SHORT
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func requestNotification() {
        Task {
            do {
                try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            } catch {
                print("Request authorization error")
            }
        }
    }
    
    private func addNotification() {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content  = UNMutableNotificationContent()
            content.title = "Tiêu đề"
            content.subtitle = "Tiêu đề phụ"
            content.sound = UNNotificationSound.default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                center.requestAuthorization(options: authOptions) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct Prospect {
    let id: Int
}

#Preview {
    MainTabView(selectedTab: .explore)
}
