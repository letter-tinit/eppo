//
//  WalletAPI.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import Foundation

struct WalletResponse: Codable {
    let statusCode: Int
    let message: String
    let data: Wallet
}

// MARK: - Wallet
struct Wallet: Codable {
    let walletId: Int
    let numberBalance: Double
    let creationDate: Date
    let modificationDate: Date
    let status: Int
    let transactions: [TransactionAPI]
}

// MARK: - Transaction
struct TransactionAPI: Codable, Identifiable {
    let id: Int
    let walletId: Int
    let description: String
    let withdrawNumber: Double?
    let rechargeNumber: Double?
    let paymentId: Int?
    let isActive: Bool?
    let rechargeDate: Date?
    let withdrawDate: Date?
    let creationDate: Date?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "transactionId"
        case walletId
        case description
        case withdrawNumber
        case rechargeNumber
        case paymentId
        case isActive
        case rechargeDate
        case withdrawDate
        case creationDate
        case status
    }
}

