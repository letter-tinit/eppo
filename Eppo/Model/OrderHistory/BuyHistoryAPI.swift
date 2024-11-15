//
//  BuyHistoryAPI.swift
//  Eppo
//
//  Created by Letter on 15/11/2024.
//

import Foundation

// Định nghĩa struct cho OrderDetail
struct BuyHistoryOrderDetail: Codable, Identifiable {
    let id: Int
    let plant: Plant
    
    enum CodingKeys: String, CodingKey {
        case id = "orderDetailId"
        case plant = "plant"
    }
}

// Định nghĩa struct cho Order
struct BuyHistoryOrder: Codable, Identifiable {
    let id: Int
    let deliveryFee: Double
    let finalPrice: Double
    let orderDetails: [BuyHistoryOrderDetail]

    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case deliveryFee = "deliveryFee"
        case finalPrice = "finalPrice"
        case orderDetails = "orderDetails"
    }
}

// Định nghĩa struct cho Response
struct BuyHistoryResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [BuyHistoryOrder]
}
