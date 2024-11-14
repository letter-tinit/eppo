//
//  Address.swift
//  Eppo
//
//  Created by Letter on 13/11/2024.
//

import Foundation

struct Address: Codable, Identifiable, Hashable{
    var id: Int
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "addressId"
        case description = "description"
    }
}
