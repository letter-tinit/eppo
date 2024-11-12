//
//  NotificationResponse.swift
//  Eppo
//
//  Created by Letter on 10/11/2024.
//

import Foundation

//{
//  "statusCode": 200,
//  "message": "Request was successful",
//  "data": [
//    {
//      "notificationId": 1,
//      "userId": 3,
//      "title": "Demo",
//      "description": "No content",
//      "isRead": false,
//      "isNotifications": false,
//      "status": 1,
//      "user": null
//    }
//  ]
//}
struct NotificationResponse: Codable {
    var statusCode: Int
    var message: String
    var data: [Notification]
}

struct Notification: Codable {
    var notificationId: Int
    var title: String
    var description: String
    var isRead: Bool
    var isNotifications: Bool
}

