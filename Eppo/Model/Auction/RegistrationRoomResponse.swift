//
//  RegistrationRoomResponse.swift
//  Eppo
//
//  Created by Letter on 18/11/2024.
//

import Foundation

struct RegisteredRoomsResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [UserRoom]
}

struct UserRoom: Codable, Identifiable {
    let id: Int
    let roomId: Int
    let room: Room
    
    enum CodingKeys: String, CodingKey{
        case id = "userRoomId"
        case roomId
        case room
    }
}

struct RegistedRoomResponse: Codable {
    let statusCode: Int
    let message: String
    let data: RegistedRoomResponseData
}

struct RegistedRoomResponseData: Codable {
    let room: RegistedRoomById
    let registeredCount: Int
    let openingCoolDown: Int
    let closingCoolDown: Int
}


struct RegistedRoomById: Codable {
    let roomId: Int
    let room: Room
}
