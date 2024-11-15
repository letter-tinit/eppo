//
//  ContractAPI.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import Foundation

import Foundation

struct ContractRequest: Encodable {
    let contractNumber: Int
    let description: String
    let creationContractDate: Date
    let endContractDate: Date
    let totalAmount: Double
    let contractDetails: [ContractDetail]
}

struct ContractDetail: Encodable {
    let plantId: Int
    let totalPrice: Double
}

struct ContractResponse: Codable {
    let contractId: Int
}
