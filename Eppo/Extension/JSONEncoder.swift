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
