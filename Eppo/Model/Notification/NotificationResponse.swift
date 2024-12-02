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
    var data: [NotificationResponseData]
}

struct NotificationResponseData: Codable, Identifiable, Hashable {
    var id: String {  // Generate a unique ID based on the date
        return date.description // Use `date` if available or UUID fallback
    }
    var date: Date
    var notifications: [NotificationAPI]
}

struct NotificationAPI: Codable, Identifiable, Hashable {
    var id: String {  // Generate a unique ID based on `createdDate`
        return createdDate.description  // Use the `createdDate` to create a unique ID
    }
    var title: String
    var description: String
    var createdDate: Date
}
