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
