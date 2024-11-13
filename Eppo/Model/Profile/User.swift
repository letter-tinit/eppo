//
//  User.swift
//  Eppo
//
//  Created by Letter on 16/10/2024.
//

import Foundation

struct User: Codable {
    let userId: Int
    let userName: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let gender: String
    let walletId: Int
    let identificationCard: Int
    let dateOfBirth: String
    let wallet: Wallet
}

struct Wallet: Codable {
    let walletId: Int
    let numberBalance: Double
}

struct UserUpdateRequest: Codable {
    var userName: String?
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var gender: String?
    var identificationCard: Int?
    var dateOfBirth: String?
}
