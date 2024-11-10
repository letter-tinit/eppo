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
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "plantId"
        case name = "plantName"
        case price = "price"
        case description = "description"
    }
}
