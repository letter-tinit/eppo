//
//  User.swift
//  Eppo
//
//  Created by Letter on 16/10/2024.
//

import Foundation

struct User: Codable {
    var userId: Int?
    var userName: String?
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var gender: String?
    var walletId: Int?
    var identificationCard: Int?
    var dateOfBirth: String?
    var wallet: Wallet?
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
