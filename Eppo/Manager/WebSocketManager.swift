//
//  WebSocketManager.swift
//  Eppo
//
//  Created by Letter on 05/10/2024.
//

import Foundation

class WebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect() {
        let url = URL(string: "wss://quangtrandeptrai-001-site1.atempurl.com/ws/chat")!
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()  // Nhận tin nhắn từ server
    }
    
    func sendMessage(text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Lỗi khi gửi: \(error)")
            }
        }
    }
    
    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Nhận tin nhắn: \(text)")
                case .data(let data):
                    print("Nhận dữ liệu: \(data)")
                @unknown default:
                    break
                }
                // Đợi nhận tin nhắn tiếp theo
                self?.receiveMessage()
            case .failure(let error):
                print("Lỗi khi nhận: \(error)")
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
