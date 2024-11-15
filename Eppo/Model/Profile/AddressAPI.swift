//
//  AddressAPI.swift
//  Eppo
//
//  Created by Letter on 12/11/2024.
//

struct CreateAddessRequest: Codable {
    let description: String
}

struct CreateAddressResponse: Codable {
    let statusCode: Int
    let message: String
    let data: DataCreateAddressResponse
}

struct DataCreateAddressResponse: Codable {
    let description: String
}

struct AddressResponse: Codable {
    let statusCode: Int
    let message: String
    let data: [Address]
}
