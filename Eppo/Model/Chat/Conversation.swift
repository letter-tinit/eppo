//
//  Conversation.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

import Foundation

struct Conversation: Codable {
    let conversationId: Int
    let userOneNavigation: User
    let userTwoNavigation: User
    let messages: [Message]
}

struct Message: Codable, Identifiable, Hashable {
    var id = UUID()
    let messageId: Int?
    let conversationId: Int
    let userId: Int
    let message1: String
    let type: String
    let imageLink: String?
    let creationDate: Date
    var isSent: Bool
    let isSeen: Bool
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case messageId = "messageId"
        case conversationId
        case userId
        case message1
        case type
        case imageLink
        case creationDate
        case isSent
        case isSeen
        case status
    }
}

struct ReceiveMessage: Codable, Identifiable, Hashable {
    let id: Int
    let conversationId: Int
    let userId: Int
    let message1: String
    let type: String
    let imageLink: String?
    let creationDate: Date
    let isSent: Bool
    let isSeen: Bool
    let status: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "MessageId"
        case conversationId = "ConversationId"
        case userId = "UserId"
        case message1 = "Message1"
        case type = "Type"
        case imageLink = "ImageLink"
        case creationDate = "CreationDate"
        case isSent = "IsSent"
        case isSeen = "IsSeen"
        case status = "Status"
    }
}

extension Message {
    init(from receiveMessage: ReceiveMessage) {
        self.messageId = receiveMessage.id
        self.conversationId = receiveMessage.conversationId
        self.userId = receiveMessage.userId
        self.message1 = receiveMessage.message1
        self.type = receiveMessage.type
        self.imageLink = receiveMessage.imageLink
        self.creationDate = receiveMessage.creationDate
        self.isSent = receiveMessage.isSent
        self.isSeen = receiveMessage.isSeen
        self.status = receiveMessage.status
    }
}
