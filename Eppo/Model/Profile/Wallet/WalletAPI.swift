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
    let creationDate: String
    let modificationDate: String
    let status: Int
    let transactions: [TransactionAPI]
}

// MARK: - Transaction
struct TransactionAPI: Codable {
    let transactionId: Int
    let walletId: Int
    let description: String
    let withdrawNumber: Double?
    let rechargeNumber: Double?
    let paymentId: Int?
    let isActive: Bool?
    let rechargeDate: String?
    let withdrawDate: String?
    let creationDate: String?
    let status: Int?
}

