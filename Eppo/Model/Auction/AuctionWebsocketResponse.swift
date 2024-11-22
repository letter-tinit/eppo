//
//  AuctionWebsocketResponse.swift
//  Eppo
//
//  Created by Letter on 20/11/2024.
//

import Foundation

// MARK: - Models for Received Data
//struct SimpleMessage: Decodable {
//    let Message: String
//}
//
//struct HistoryBid: Codable, Identifiable {
//    let HistoryBidId: Int
//    let UserId: Int
//    let RoomId: Int
//    let BidAmount: Int
//    let PriceAuctionNext: Int
//    let BidTime: String
//    let IsWinner: Bool?
//    let IsActive: Bool
//    let IsPayment: Bool?
//    let Status: Int
//    let UserName: String
//    
//    var id: Int {
//        return HistoryBidId
//    }
//}
//
//
//struct ComplexMessage: Decodable {
//    let Message: String
//    let HistoryBid: HistoryBid?
//}

struct HistoryBid: Codable, Identifiable, Hashable {
    let id: Int
    let roomId: Int
    let bidAmount: Int
    let bidTime: String
    let priceAuctionNext: Int
    let isActive: Bool
    let status: Int
    let userName: String

    // Đặt CodingKeys để map với các key trong JSON
    enum CodingKeys: String, CodingKey {
        case id = "UserId"
        case roomId = "RoomId"
        case bidAmount = "BidAmount"
        case bidTime = "BidTime"
        case priceAuctionNext = "PriceAuctionNext"
        case isActive = "IsActive"
        case status = "Status"
        case userName = "UserName"
    }
}

// Định nghĩa struct cho JSON gốc
struct RootResponse: Codable {
    let message: String
    let historyBid: HistoryBid

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case historyBid = "HistoryBid"
    }
}
