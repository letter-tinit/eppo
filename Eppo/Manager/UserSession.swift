//
//  UserSession.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//
import Foundation

class UserSession {
    static let shared = UserSession() // Singleton instance
    
    private init() {
        loadToken() // Load the token when the session is initialized
    }
    
    var token: String? {
        didSet {
            if let token = token {
                // Save the token to UserDefaults when it's set
                UserDefaults.standard.set(token, forKey: Token.access)
            } else {
                // Remove token from UserDefaults when token is cleared
                UserDefaults.standard.removeObject(forKey: Token.access)
            }
        }
    }
    
    // Save token to UserDefaults
    func saveToken(_ token: String) {
        self.token = token
    }
    
    // Load token from UserDefaults
    func loadToken() {
        self.token = UserDefaults.standard.string(forKey: Token.access)
    }
    
    // Clear token from UserDefaults
    func clearSession() {
        token = nil
    }
}
