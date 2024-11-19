//
//  Plant.swift
//  Eppo
//
//  Created by Letter on 01/11/2024.
//

import Foundation

struct Plant: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let price: Double
    let finalPrice: Double
    let description: String
    
    // computed value
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "plantId"
        case name = "plantName"
        case price = "price"
        case finalPrice = "finalPrice"
        case description = "description"
    }
}

struct PlantResponse: Codable {
    let statusCode: Int
    let message: String
    let data: Plant
}
