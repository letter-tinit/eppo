//
//  LoginAPI.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

struct LoginRequest: Codable {
    let userName: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "usernameOrEmail"
        case password = "password"
    }
}

struct LoginResponse: Codable {
    let token: String
    let roleName: String
    let isSigned: Bool?
}
