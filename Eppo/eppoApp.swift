//
//  EppoApp.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI
import UIKit
import zpdk
import zlib
import CommonCrypto

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ZaloPaySDK.sharedInstance()?.initWithAppId(553, uriScheme: "testcheme", environment: .sandbox)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ZaloPaySDK.sharedInstance().application(app, open: url, sourceApplication:"vn.com.vng.zalopay", annotation: nil)
    }
    
}

@main
struct EppoApp: App {
    @State private var networkMonitor = NetworkMonitor()
    @AppStorage("isLogged") var isLogged: Bool = false
    @AppStorage("isCustomer") var isCustomer: Bool = false
    @AppStorage("isOwner") var isOwner: Bool = false
    @AppStorage("isSigned") var isSigned: Bool = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if isLogged {
                if isCustomer {
                    MainTabView(selectedTab: .profile)
                        .environment(networkMonitor)
                } else if isOwner {
                    if isSigned {
                        OwnerMainTabView()
                            .environment(networkMonitor)
                    } else {
                        OwnerContractView()
                            .environment(networkMonitor)
                    }
                } else {
                    EmptyView()
                }
            } else {
                LoginScreen()
            }
        }
    }
}
