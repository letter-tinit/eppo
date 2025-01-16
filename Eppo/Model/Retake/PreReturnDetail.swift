//
//  PreReturnDetail.swift
//  Eppo
//
//  Created by Treasure Letter on 15/01/2025.
//

import Foundation

struct PreReturnDetail: Codable {
//    let orderId: Int
//    let deliveryFee: Double
//    let finalPrice: Double
//    let orderDetails: [PreReturnOrderDetail]
    var order: PreReturnOrder
    let contract: ContractURLResponse
    let plant: Plant
}

struct PreReturnOrderDetail: Codable {
    let orderDetailId: Int
    let rentalStartDate: Date
    let rentalEndDate: Date
    let numberMonth: Int
    let depositDescription: String
    var isReturnSoon: Bool
    let priceRentalReturnObject: Double
    let plant: Plant
}

struct PreReturnOrder: Codable {
    let orderId: Int
    let deliveryFee: Double
    let finalPrice: Double
    var orderDetails: [PreReturnOrderDetail]
}
