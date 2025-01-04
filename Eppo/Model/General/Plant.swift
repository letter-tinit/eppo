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
    let code: String
    var plantUser: PlantUser?

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
        case code = "code"
        case plantUser = "plantUser"
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

struct PlantUser: Codable, Hashable {
    let fullName: String
    let phoneNumber: String
    let email: String
    let imageUrl: String
}
