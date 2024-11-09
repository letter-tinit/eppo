//
//  CategoryResponse.swift
//  Eppo
//
//  Created by Letter on 07/11/2024.
//

import Foundation

struct CategoryResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Category]
}
