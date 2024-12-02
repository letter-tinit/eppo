//
//  OwnerContractAPI.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

import Foundation


struct OwnerContractResponse: Codable {
    let statusCode: Int
    let message: String
    let contractId: Int?
    let pdfUrl: String?
    let existingContract: ExistingContract?
}

struct OwnerContractRequest: Codable {
    let contractUrl: String
    let contractDetails: [OwnerContractDetail]
}

struct OwnerContractDetail: Codable {
    // Add properties as needed for each contract detail.
}

struct ExistingContract: Codable {
    let contractId: Int
    let contractUrl: String
}

