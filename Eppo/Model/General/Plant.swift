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
    let title: String
    let finalPrice: Double
    let description: String
    let mainImage: String
    let imagePlants: [ImagePlantResponse]
    let status: Int
    let isActive: Bool
    let typeEcommerceId: Int

    // computed property for mutability
    var isSelected: Bool = false {
        didSet {
            // Không ảnh hưởng đến Hashable
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "plantId"
        case name = "plantName"
        case title
        case finalPrice = "finalPrice"
        case description = "description"
        case mainImage
        case imagePlants = "imagePlants"
        case status = "status"
        case isActive = "isActive"
        case typeEcommerceId = "typeEcommerceId"
    }
}

struct ImagePlantResponse: Codable, Identifiable, Hashable {
    var id: Int
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "plantId"
        case imageUrl
    }
}

struct PlantResponse: Codable {
    let statusCode: Int
    let message: String
    let data: Plant
}

struct PlantCreationResponse: Codable {
    let statusCode: Int
    let message: String
}
