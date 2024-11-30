//
//  FeedBackAPI.swift
//  Eppo
//
//  Created by Letter on 28/11/2024.
//

import Foundation

import Foundation

//struct FeedBackOrderDetail: Codable, Identifiable {
//    let id: Int
//    let plant: Plant
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "orderDetailId"
//        case plant = "plant"
//    }
//}
//
//struct FeedBackOrder: Codable, Identifiable {
//    let id: Int
//    let deliveryFee: Double
//    let finalPrice: Double
//    let orderDetails: [FeedBackOrderDetail]
//
//    enum CodingKeys: String, CodingKey {
//        case id = "orderId"
//        case deliveryFee = "deliveryFee"
//        case finalPrice = "finalPrice"
//        case orderDetails = "orderDetails"
//    }
//}

struct FeedBackResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Plant]
}
