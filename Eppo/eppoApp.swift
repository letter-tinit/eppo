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
    
    var body: some Scene {
        WindowGroup {
            if isLogged {
                MainTabView()
                    .environment(networkMonitor)
            } else {
                LoginScreen()
            }
        }
    }
}
