//
//  AuctionResponse.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation

struct AuctionResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Room]
}

struct AuctionDetailResponse: Codable {
    let statusCode: Int
    let message: String
    let data: RoomResponseData
}

struct RoomResponseData: Codable {
    let room: Room
    let registeredCount: Int
    let openingCoolDown: Int
    let closingCoolDown: Int
}

