//
//  HireHistoryAPI.swift
//  Eppo
//
//  Created by Letter on 15/11/2024.
//

import Foundation

// Định nghĩa struct cho OrderDetail
struct HireHistoryOrderDetail: Codable {
    let orderDetailId: Int
    let rentalStartDate: Date
    let rentalEndDate: Date
    let numberMonth: Int
    let plant: Plant
}

// Định nghĩa struct cho Order
struct HireHistoryOrder: Codable, Identifiable {
    let id: Int
    let deliveryFee: Double
    let finalPrice: Double
    let orderDetails: [HireHistoryOrderDetail]
    let paymentStatus: String

    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case deliveryFee = "deliveryFee"
        case finalPrice = "finalPrice"
        case orderDetails = "orderDetails"
        case paymentStatus = "paymentStatus"
    }
}

// Định nghĩa struct cho Response
struct HireHistoryResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [HireHistoryOrder]
}
//
//// Ví dụ tạo một đối tượng Response với dữ liệu giả
//let response = Response(
//    statusCode: 200,
//    message: "Yêu cầu thành công.",
//    data: [
//        Order(
//            orderId: 65,
//            userId: 3,
//            totalPrice: 0,
//            deliveryFee: 0,
//            deliveryAddress: "string",
//            finalPrice: 0,
//            typeEcommerceId: 2,
//            paymentId: nil,
//            paymentStatus: "Chưa thanh toán",
//            status: 1,
//            creationDate: "2024-11-15T10:19:17",
//            modificationDate: nil,
//            orderDetails: [
//                OrderDetail(
//                    orderDetailId: 53,
//                    orderId: 65,
//                    plantId: 16,
//                    rentalStartDate: "2024-11-15T03:19:07",
//                    rentalEndDate: "2024-11-15T03:19:07",
//                    numberMonth: 0
//                )
//            ]
//        )
//    ]
//)
