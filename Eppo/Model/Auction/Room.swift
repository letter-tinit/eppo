//
//  Room.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation

struct Room: Codable, Hashable {
    let roomId: Int
    let plantId: Int
    let plant: Plant
    let registrationOpenDate: Date
    let registrationEndDate: Date
    let registrationFee: Double
    let priceStep: Double
    let activeDate: Date
    let endDate: Date
    let userRooms: [IsActiveUserRoom?]
}

struct IsActiveUserRoom: Codable, Hashable {
    let isActive: Bool?
}
