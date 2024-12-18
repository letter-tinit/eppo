//
//  OrderAPI.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import Foundation

struct OrderDetail: Codable {
    var plantId: Int
    var rentalStartDate: Date  // Có thể sử dụng Date nếu cần, nhưng với định dạng này là String
    var numberMonth: Int
    var deposit: Double
}

// Định nghĩa struct cho Order
struct Order: Codable {
    var totalPrice: Double
    var deliveryFee: Double
    var deliveryAddress: String
    var orderDetails: [OrderDetail]
}

struct OrderResponse: Codable {
    let statusCode: Int
    let message: String
    let data: OrderResponseData
}

struct OrderResponseData: Codable {
    let orderId: Int
}

struct GetContractByIdResponse: Codable {
    let statusCode: Int
    let message: String
    let data: ContractURLResponse
}

struct ContractURLResponse: Codable {
    let contractUrl: String
}

struct ShippingFeeResponse: Codable {
    let statusCode: Int
    let message: String
    let data: Double
}

struct UpdatePaymentResponse: Codable {
    let statusCode: Int
    let message: String
}
