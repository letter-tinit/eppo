//
//  FeedBackAPI.swift
//  Eppo
//
//  Created by Letter on 30/11/2024.
//

import Foundation

struct FeedBacksResponse: Codable {
    let statusCode: Int
    let message: String
    let data: FeedBackData
}

struct FeedBackData: Codable {
    let feedbacks: [FeedBack]
    let totalRating: Double
    let numberOfFeedbacks: Int
}

struct FeedBack: Codable, Identifiable {
    let id: Int
    let description: String
    let imageFeedbacks: [ImageFeedBack]
    let rating: Double
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id = "feedbackId"
        case description
        case imageFeedbacks
        case rating
        case user
    }
}

struct ImageFeedBack: Codable, Identifiable {
    let id: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "imgageFeedbackId"
        case imageUrl
    }
}
