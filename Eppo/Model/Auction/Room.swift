//
//  Room.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation

struct Room: Codable, Hashable {
    let roomId: Int
    let activeDate: String
    let plantId: Int
    let plant: Plant
}
