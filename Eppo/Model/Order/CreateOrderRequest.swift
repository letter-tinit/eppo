//
//  CreateOrderRequest.swift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import Foundation

struct CreateOrderRequest: Encodable {
    let totalPrice: Double
    var deliveryFee: Double
    var deliveryAddress: String
    var paymentId: Int
    let orderDetails: [Plant]
}
