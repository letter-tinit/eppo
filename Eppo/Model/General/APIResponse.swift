//
//  APIResponse.swift
//  Eppo
//
//  Created by Letter on 10/12/2024.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T?
}

struct NoDataResponse: Decodable {}

