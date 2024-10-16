//
//  User.swift
//  Eppo
//
//  Created by Letter on 16/10/2024.
//

import Foundation

struct User: Codable {
    let userId: String
    let roleId: String
    let roleName: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let gender: String
    let rankId: String
    let walletId: String
    let identificationCard: String
    let dateOfBirth: String
    let role: String
    
    enum CodingKeys: String, CodingKey {
        case userId, roleId, roleName, fullName, email, phoneNumber, gender, rankId, walletId, identificationCard, dateOfBirth
        case role = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
    }
}
