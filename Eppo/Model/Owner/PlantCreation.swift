//
//  PlantCreation.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import Foundation
import UIKit

struct OwnerItem: Codable {
    var itemName: String
    var itemDescription: String
    var price: Double
    var width: Double
    var length: Double
    var height: Double
    var categoryId: String
    var mainImageData: Data
    var additionalImagesData: [Data]
}
