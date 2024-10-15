//
//  LoginAPI.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

struct LoginRequest: Codable {
    let userName: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}
