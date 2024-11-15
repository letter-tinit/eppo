//
//  JSONEncoder.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import Foundation

extension JSONEncoder {
    
    static var iso8601Encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension JSONDecoder {
    static var customDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // adjust this format to match your API's date format
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
