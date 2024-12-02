//
//  OwnerOrderAPI.swift
//  Eppo
//
//  Created by Letter on 28/11/2024.
//

import Foundation

// Định nghĩa struct cho OrderDetail
struct OwnerOrderDetail: Codable {
    let orderDetailId: Int
    let rentalStartDate: Date?
    let rentalEndDate: Date?
    let numberMonth: Int?
    let plant: Plant
}

// Định nghĩa struct cho Order
struct OwnerOrder: Codable, Identifiable {
    let id: Int
    let deliveryFee: Double
    let deliveryAddress: String
    let finalPrice: Double
    let typeEcommerceId: Int
    let orderDetails: [OwnerOrderDetail]
    let paymentStatus: String
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case deliveryFee = "deliveryFee"
        case deliveryAddress = "deliveryAddress"
        case finalPrice = "finalPrice"
        case typeEcommerceId = "typeEcommerceId"
        case orderDetails = "orderDetails"
        case paymentStatus = "paymentStatus"
        case status = "status"
    }
}

// Định nghĩa struct cho Response
struct OwnerOrderResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [OwnerOrder]
}
