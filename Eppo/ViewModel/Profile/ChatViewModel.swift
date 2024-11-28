//
//  ChatViewModel.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

import Foundation
import Combine
import Observation

@Observable
class ChatViewModel {
    var messages: [Message] = []
    var messageTextField: String = ""
    var cancellables: Set<AnyCancellable> = []
    var conversationId: Int = 0
    var myId: Int = 0
    var isSending: Bool = false
    var hasError: Bool = false
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isConnected = false // Track connection state
    
    func connectWebSocket() {
        if let token = UserSession.shared.token {
            connectWebSocket(token: token)
        }
    }
    
    func sendMessage() {
        isSending = true
        hasError = false
        let message = Message(id: UUID(), messageId: 1, conversationId: conversationId, userId: self.myId, message1: messageTextField, type: "text", imageLink: nil, creationDate: Date.now, isSent: true, isSeen: false, status: 1)
        
        guard isConnected else {
            print("Socket is not connected")
            return
        }
        
        let messageDict: [String: Any] = [
            "ConversationId": conversationId,
            "Message1": messageTextField,
            "Type": "text",
            "ImageLink": NSNull()
        ]
        let messageData = try! JSONSerialization.data(withJSONObject: messageDict)
        let messageString = String(data: messageData, encoding: .utf8)!
        
        webSocketTask?.send(.string(messageString)) { [weak self] error in
            if let error = error {
                print("Error sending message: \(error)")
                self?.isSending = false
                self?.hasError = true
            } else {
                print("Message sent successfully")
                self?.isSending = false
                self?.messages.append(message)
                self?.messageTextField = ""
            }
        }
    }
    
    // MARK: - WebSocket Connection
    
    private func connectWebSocket(token: String) {
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
    
    private func sendAuthMessage(token: String) {
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
    
    // MARK: - Receiving Messages
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        print("Received message: \(text)")
                        self?.processReceivedMessage(text)
                    }
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            print("Received message: \(text)")
                            self?.processReceivedMessage(text)
                        }
                    }
                @unknown default:
                    print("Unknown message type received")
                }
            case .failure(let error):
                print("Error receiving message: \(error)")
                self?.isConnected = false
                if let token = UserSession.shared.token {
                    self?.connectWebSocket(token: token)
                }
            }
            
            // Continue listening for more messages
            self?.receiveMessage()
        }
    }
    
    // MARK: - Process Received Message
    
    private func processReceivedMessage(_ message: String) {
        if let receivedMessage = decodeMessage(from: message) {
            let message = Message(from: receivedMessage)
            print(message)
            self.messages.append(message)
        } else {
            print("Failed to decode message")
        }
    }
    
    private func decodeMessage(from jsonString: String) -> ReceiveMessage? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Unable to convert string to Data")
            return nil
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let message = try decoder.decode(ReceiveMessage.self, from: jsonData)
            return message
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // MARK: - Closing WebSocket
    
    func closeWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket connection closed")
    }

    // MARK: - Get Messages
    
    func getMessages() {
        APIManager.shared.getAllConversation()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] conversations in
                let conversation = conversations[0]
                if let myId = UserSession.shared.myInformation?.userId {
                    self?.myId = myId
                }
                self?.messages = conversation.messages
                self?.conversationId = conversation.conversationId
            }
            .store(in: &cancellables)
    }
}
