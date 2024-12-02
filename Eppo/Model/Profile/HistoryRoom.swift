//
//  HistoryRoom.swift
//  Eppo
//
//  Created by Letter on 02/12/2024.
//

import Foundation

struct HistoryRoomResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [HistoryRoom]
}

struct HistoryRoom: Codable, Identifiable, Hashable {
    let id = UUID()
    let roomId: Int
    let roomName: String
    let image: String
    let registrationFee: Int
    let priceStep: Int
    let endDate: Date
    let userBidAmount: Int
    let userIsWinner: Bool
    let winningBid: Int
    
    // Custom initializer to provide default values
    init(
        roomId: Int,
        roomName: String? = nil,
        image: String? = nil,
        registrationFee: Int,
        priceStep: Int,
        endDate: Date,
        userBidAmount: Int? = nil,
        userIsWinner: Bool? = nil,
        winningBid: Int? = nil
    ) {
        self.roomId = roomId
        self.roomName = roomName ?? ""  // Default empty string for roomName
        self.image = image ?? "https://example.com/placeholder.jpg" // Default URL for image
        self.registrationFee = registrationFee
        self.priceStep = priceStep
        self.endDate = endDate
        self.userBidAmount = userBidAmount ?? 0  // Default to 0 if nil
        self.userIsWinner = userIsWinner ?? false  // Default to false if nil
        self.winningBid = winningBid ?? 0  // Default to 0 if nil
    }
    
    // Custom decoding logic to handle null values with defaults
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        roomId = try container.decode(Int.self, forKey: .roomId)
        roomName = try container.decodeIfPresent(String.self, forKey: .roomName) ?? ""  // Default to empty string
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        registrationFee = try container.decode(Int.self, forKey: .registrationFee)
        priceStep = try container.decode(Int.self, forKey: .priceStep)
        endDate = try container.decode(Date.self, forKey: .endDate)
        userBidAmount = try container.decodeIfPresent(Int.self, forKey: .userBidAmount) ?? 0  // Default to 0
        userIsWinner = try container.decodeIfPresent(Bool.self, forKey: .userIsWinner) ?? false  // Default to false
        winningBid = try container.decodeIfPresent(Int.self, forKey: .winningBid) ?? 0  // Default to 0
    }
    
    // Custom encoding logic to ensure default values are encoded
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(roomId, forKey: .roomId)
        try container.encode(roomName, forKey: .roomName)
        try container.encode(image, forKey: .image)
        try container.encode(registrationFee, forKey: .registrationFee)
        try container.encode(priceStep, forKey: .priceStep)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(userBidAmount, forKey: .userBidAmount)
        try container.encode(userIsWinner, forKey: .userIsWinner)
        try container.encode(winningBid, forKey: .winningBid)
    }
    
    enum CodingKeys: String, CodingKey {
        case roomId, roomName, image, registrationFee, priceStep, endDate, userBidAmount, userIsWinner, winningBid
    }
}
