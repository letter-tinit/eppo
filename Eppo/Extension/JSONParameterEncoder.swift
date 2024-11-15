//
//  JSONParameterEncoder.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import Foundation
import Alamofire

extension JSONParameterEncoder {
    static var iso8601: JSONParameterEncoder {
        return JSONParameterEncoder(encoder: JSONEncoder.iso8601Encoder)
    }
}
