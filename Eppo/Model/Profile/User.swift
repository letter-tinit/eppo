//
//  User.swift
//  Eppo
//
//  Created by Letter on 16/10/2024.
//

import Foundation

struct User: Codable {
    var userId: Int
    var userName: String
    var fullName: String
    var gender: String
    var dateOfBirth: Date
    var phoneNumber: String
    var email: String
    var imageUrl: String?
    var identificationCard: String
    var walletId: Int?
    var wallet: Wallet?
}

extension User {
    func isAllFieldsInputted() -> Bool {
        // Check string properties are not empty and date is valid
        return !fullName.isEmpty &&
        !gender.isEmpty &&
        !phoneNumber.isEmpty &&
        !identificationCard.isEmpty &&
        !email.isEmpty &&
        dateOfBirth != Date.distantPast
    }
}
