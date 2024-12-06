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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 7 * 3600)
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        // Alternatively, use .iso8601 if the format strictly adheres to ISO standards
        // decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    static var customSimpleDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
