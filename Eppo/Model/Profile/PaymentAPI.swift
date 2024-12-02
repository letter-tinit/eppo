//
//  PaymentAPI.swift
//  Eppo
//
//  Created by Letter on 23/11/2024.
//

import Foundation

struct TransactionResponse: Decodable {
    let return_code: Int
    let return_message: String
    let sub_return_code: Int
    let sub_return_message: String
    let zp_trans_token: String?
    let order_url: String?
    let order_token: String?
    let qr_code: String?
}

