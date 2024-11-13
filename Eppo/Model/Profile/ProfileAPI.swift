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
