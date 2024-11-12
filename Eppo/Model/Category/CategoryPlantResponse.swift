//
//  CategoryPlantResponse.swift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import Foundation

struct CategoryPlantResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Plant]
}
