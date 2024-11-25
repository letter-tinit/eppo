//
//  DateExtension.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation

extension Date {
    var iso8601String: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Định dạng khớp với API
        formatter.timeZone = TimeZone(abbreviation: "UTC") // Đảm bảo sử dụng múi giờ UTC
        return formatter.string(from: self)
    }
}
