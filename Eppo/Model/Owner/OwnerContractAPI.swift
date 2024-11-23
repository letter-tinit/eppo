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
    let pdfUrl: String
}

struct OwnerContractRequest: Codable {
    let contractUrl: String
    let contractDetails: [OwnerContractDetail]
}

struct OwnerContractDetail: Codable {
    // Add properties as needed for each contract detail.
}

