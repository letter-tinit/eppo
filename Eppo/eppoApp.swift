//
//  EppoApp.swift
//  eppo
//
//  Created by Letter on 31/07/2024.
//

import SwiftUI

@main
struct EppoApp: App {
    @AppStorage("isLogged") var isLogged: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLogged {
                MainTabView()
            } else {
                LoginScreen()
            }
        }
    }
}
