//
//  AuctionWebSocket.swift
//  Eppo
//
//  Created by Letter on 18/11/2024.
//

import Foundation

class AuctionWebSocket: ObservableObject {
    static let shared = AuctionWebSocket() // Singleton instance
    
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var receivedMessages: [String] = [] // Store received messages
    private var isConnected = false // Track connection state
    
    private init() {} // Prevent external instantiation
    
    // MARK: - WebSocket Connection
    
    /// Connects to the WebSocket and sends the authentication token.
    func connectWebSocket(token: String) {
        guard let url = URL(string: "wss://sep490ne-001-site1.atempurl.com/ws/chat") else {
            print("Invalid WebSocket URL")
            return
        }
                
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage() // Start listening for incoming messages
        
        // Delay sending the authentication message until the WebSocket is connected
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.sendAuthMessage(token: token)
        }
    }
    
    // MARK: - Authentication
    
    /// Sends the authentication token to the server.
    func sendAuthMessage(token: String) {
        let tokenMessage: [String: Any] = ["token": token] // Use the passed token
        let tokenData = try! JSONSerialization.data(withJSONObject: tokenMessage)
        let tokenString = String(data: tokenData, encoding: .utf8)!
        
        webSocketTask?.send(.string(tokenString)) { error in
            if let error = error {
                print("Error sending token: \(error)")
            } else {
                self.isConnected = true // Update connection state on successful token send
                print("Token sent successfully")
            }
        }
    }
    // MARK: - Sending Messages
    
    /// Sends a chat message to the server.
    func sendMessage(conversationId: Int, message: String, messageType: String = "text", imageLink: String? = nil) {
        guard isConnected else {
            print("Socket is not connected")
            return
        }
        
        let messageDict: [String: Any] = [
            "ConversationId": conversationId,
            "Message1": message,
            "Type": messageType,
            "ImageLink": imageLink ?? NSNull()
        ]
        let messageData = try! JSONSerialization.data(withJSONObject: messageDict)
        let messageString = String(data: messageData, encoding: .utf8)!
        
        webSocketTask?.send(.string(messageString)) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully")
            }
        }
    }
    
    // MARK: - Receiving Messages
    
    /// Continuously listens for incoming messages from the server.
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.receivedMessages.append(text)
                        print("Received message: \(text)")
                    }
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self?.receivedMessages.append(text)
                            print("Received message: \(text)")
                        }
                    }
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Error receiving message: \(error)")
                self?.isConnected = false // Update connection state on failure
            }
            
            // Continue listening for more messages
            self?.receiveMessage()
        }
    }
    
    // MARK: - Closing WebSocket
    
    /// Closes the WebSocket connection.
    func closeWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket connection closed")
    }
}

