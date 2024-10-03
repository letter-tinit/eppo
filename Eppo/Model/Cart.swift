//
//  Cart.swift
//  Eppo
//
//  Created by Letter on 02/10/2024.
//

import Foundation


struct Cart: Codable, Identifiable, Hashable {
    let id: Int
    let cartName: String
    var isCheckedOut: Bool
    let originalPrice: Double
    let currentPrice: Double
    var quantity: Int
    let remainingQuantity: Int
}
