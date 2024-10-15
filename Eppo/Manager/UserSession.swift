//
//  UserSession.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//


import Foundation

class UserSession {
    static let shared = UserSession() // Singleton instance
    
    private init() { } // Private initializer to prevent external instantiation
    
    // Properties to store user data
    var token: String?
    
    // Other user data can be added here (e.g., user ID, username, etc.)
    
    func saveToken(_ token: String) {
        self.token = token
        // Here, you can also save the token in UserDefaults if you want persistence
        UserDefaults.standard.set(token, forKey: Token.access)
    }
    
    func loadToken() {
        self.token = UserDefaults.standard.string(forKey: Token.access)
    }
    
    func clearSession() {
        token = nil
        UserDefaults.standard.removeObject(forKey: Token.access)
    }
}
