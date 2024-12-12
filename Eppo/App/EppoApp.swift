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
import UserNotifications
import Observation

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


@Observable
class CustomAppDelegate: NSObject, UIApplicationDelegate {
    var app: EppoApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // This is where we register this device to recieve push notifications from Apple
        // All this function does is register the device with APNs, it doesn't set up push notifications by itself
        application.registerForRemoteNotifications()
        
        // Setting the notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Once the device is registered for push notifications Apple will send the token to our app and it will be available here.
        // This is also where we will forward the token to our push server
        // If you want to see a string version of your token, you can use the following code to print it out
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    // This function lets us do something when the user interacts with a notification
    // like log that they clicked it, or navigate to a specific screen
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
            print("Got notification title: ", response.notification.request.content.title)
    }
    
    // This function allows us to view notifications in the app even with it in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // These options are the options that will be used when displaying a notification with the app in the foreground
        // for example, we will be able to display a badge on the app a banner alert will appear and we could play a sound
        return [.badge, .banner, .list, .sound]
    }
}

@main
struct EppoApp: App {
    @State private var networkMonitor = NetworkMonitor()
    @AppStorage("isLogged") var isLogged: Bool = false
    @AppStorage("isCustomer") var isCustomer: Bool = false
    @AppStorage("isOwner") var isOwner: Bool = false
    @AppStorage("isSigned") var isSigned: Bool = false
    @AppStorage("isBiometricToggled") var isBiometricToggled: Bool = false

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @UIApplicationDelegateAdaptor private var customAppDelegate: CustomAppDelegate
    
    var body: some Scene {
        WindowGroup {
            if isLogged {
                if isCustomer {
                    MainTabView(selectedTab: .explore)
                        .environment(networkMonitor)
                        .onAppear {
                            customAppDelegate.app = self
                        }
                } else if isOwner {
                    if isSigned {
                        OwnerMainTabView()
                            .environment(networkMonitor)
                            .onAppear {
                                customAppDelegate.app = self
                            }
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
