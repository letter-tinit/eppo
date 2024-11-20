//
//  EppoApp.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI

@main
struct EppoApp: App {
    @State private var networkMonitor = NetworkMonitor()
    @AppStorage("isLogged") var isLogged: Bool = false
    @AppStorage("isCustomer") var isCustomer: Bool = false
    @AppStorage("isOwner") var isOwner: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLogged {
                if isCustomer {
                    MainTabView()
                        .environment(networkMonitor)
                } else if isOwner {
                    OwnerMainTabView()
                        .environment(networkMonitor)
                } else {
                    EmptyView()
                }
            } else {
                LoginScreen()
            }
        }
    }
}
