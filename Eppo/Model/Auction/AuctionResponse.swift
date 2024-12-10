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


struct AuctionDetailHistoryResponse: Codable {
    let statusCode: Int
    let message: String
    let priceAuctionNext: Double
    let data: [BidHistory]
}

struct BidHistory: Codable, Identifiable {
    let id: Int
    let userId: Int
    let roomId: Int
    var bidAmount: Int
    let priceAuctionNext: Int
    var bidTime: Date
    let isWinner: Bool?
    let isActive: Bool
    let isPayment: Bool?
    let status: Int
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case id = "historyBidId"
        case userId
        case roomId
        case bidAmount
        case priceAuctionNext
        case bidTime
        case isWinner
        case isActive
        case isPayment
        case status
        case user
    }
}
