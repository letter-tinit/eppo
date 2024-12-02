//
//  ProfileAPI.swift
//  Eppo
//
//  Created by Letter on 12/11/2024.
//

import Foundation

struct UserResponse: Codable {
    let statusCode: Int
    let message: String
    let data: User
}

struct UpdateErrorResponse: Codable {
    let message: String
    let error: String

    enum CodingKeys: String, CodingKey {
        case message
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? container.decode(String.self, forKey: .message)) ?? "No message provided"
        error = (try? container.decode(String.self, forKey: .error)) ?? "No error provided"
    }
}

struct UserResponseTest: Codable {
    let statusCode: Int
    let message: String
    let data: UserTest?
}

struct UserTest: Codable {
    var userId: Int?
    var userName: String?
    var fullName: String?
    var gender: String?
    var dateOfBirth: String?
    var phoneNumber: String?
    var email: String?
    var imageUrl: String?
    var identificationCard: String?
    var walletId: Int?
    var wallet: WalletTest?
}

struct WalletTest: Codable {
    let walletId: Int
    let numberBalance: Double
//    let creationDate: Date
//    let modificationDate: Date
//    let status: Int
//    let transactions: [TransactionAPI]
}
