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
