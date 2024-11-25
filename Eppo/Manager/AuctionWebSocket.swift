////
////  AuctionWebSocket.swift
////
//
//import Foundation
//
//class AuctionWebSocket: ObservableObject {
//    let roomId: Int
//    let token: String
//    private var webSocketTask: URLSessionWebSocketTask?
//    @Published var receivedMessages: [String] = []
//    @Published var currentErrorMessage: String? // Store error messages, if any
//    @Published var currentHistoryBid: HistoryBid? // Store the most recent history bid
//    private var isConnected = false
//    private var reconnectAttempts = 0
//    private let maxReconnectAttempts = 5
//    
//    init(roomId: Int) {
//        self.roomId = roomId
//        if let token = UserSession.shared.token {
//            self.token = token
//        } else {
//            self.token = "NO_TOKEN"
//        }
//        self.connectWebSocket()
//    }
//    
//    // MARK: - Kết Nối WebSocket
//    func connectWebSocket() {
//        guard let url = URL(string: "wss://sep490ne-001-site1.atempurl.com/ws/auction") else {
//            print("Invalid WebSocket URL")
//            return
//        }
//        
//        let session = URLSession(configuration: .default)
//        webSocketTask = session.webSocketTask(with: url)
//        webSocketTask?.resume() // Bắt đầu kết nối
//        
//        // Gửi token xác thực sau khi kết nối
//        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
//            self.sendAuthMessage()
//        }
//        
//        receiveMessage() // Lắng nghe tin nhắn
//    }
//    
//    // MARK: - Gửi Token Xác Thực
//    func sendAuthMessage() {
//        guard let webSocketTask = webSocketTask else {
//            print("WebSocket task is not initialized")
//            return
//        }
//        
//        let authMessage: [String: Any] = ["Token": token, "RoomId": roomId]
//        guard let authData = try? JSONSerialization.data(withJSONObject: authMessage),
//              let authString = String(data: authData, encoding: .utf8) else {
//            print("Failed to serialize auth message")
//            return
//        }
//        
//        webSocketTask.send(.string(authString)) { error in
//            if let error = error {
//                print("Error sending auth message: \(error)")
//            } else {
//                print("Authentication message sent successfully")
//                self.isConnected = true
//            }
//        }
//    }
//    
//    // MARK: - Gửi Tin Nhắn
//    func sendMessage(roomId: Int, bidAmount: Int) {
//        guard isConnected else {
//            print("Socket is not connected")
//            self.handleReconnection() // Try to reconnect if not connected
//            return
//        }
//        
//        let message: [String: Any] = [
//            "RoomId": roomId,
//            "BidAmount": bidAmount
//        ]
//        guard let messageData = try? JSONSerialization.data(withJSONObject: message),
//              let messageString = String(data: messageData, encoding: .utf8) else {
//            print("Failed to serialize message")
//            return
//        }
//        
//        webSocketTask?.send(.string(messageString)) { error in
//            if let error = error {
//                print("Error sending message: \(error)")
//            } else {
//                print("Message sent successfully")
//            }
//        }
//    }
//    
//    // MARK: - Nhận Tin Nhắn
//    private func receiveMessage() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    DispatchQueue.main.async {
//                        self?.receivedMessages.append(text)
//                        print("Received message: \(text)")
//                        self?.processReceivedMessage(text)
//                    }
//                case .data(let data):
//                    if let text = String(data: data, encoding: .utf8) {
//                        DispatchQueue.main.async {
//                            self?.receivedMessages.append(text)
//                            print("Received message: \(text)")
//                            self?.processReceivedMessage(text)
//                        }
//                    }
//                @unknown default:
//                    print("Unknown message type received")
//                }
//            case .failure(let error):
//                print("Error receiving message: \(error)")
//                self?.isConnected = false
//                self?.handleReconnection()
//            }
//            
//            // Tiếp tục lắng nghe
//            self?.receiveMessage()
//        }
//    }
//    
//    // MARK: - Xử Lý Kết Nối Lại
//    private func handleReconnection() {
//        guard reconnectAttempts < maxReconnectAttempts else {
//            print("Max reconnection attempts reached")
//            return
//        }
//        
//        reconnectAttempts += 1
//        print("Attempting to reconnect (\(reconnectAttempts)/\(maxReconnectAttempts))...")
//        
//        closeWebSocket()
//        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
//            self?.connectWebSocket()
//        }
//    }
//    
//    // MARK: - Xử lý Tin Nhắn Nhận Được
//    private func processReceivedMessage(_ message: String) {
//        let data = Data(message.utf8)
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601 // Optional for parsing `BidTime`
//        
//        // Step 1: Decode to `ComplexMessage`
//        if let complexMessage = try? decoder.decode(ComplexMessage.self, from: data) {
//            if let historyBid = complexMessage.HistoryBid {
//                // Save the history bid information to the published property
//                DispatchQueue.main.async {
//                    self.currentHistoryBid = historyBid
//                }
//                print("New Auction: \(complexMessage.Message)")
//                print("Price Auction Next: \(historyBid.PriceAuctionNext)")
//            } else {
//                DispatchQueue.main.async {
//                    self.currentErrorMessage = complexMessage.Message
//                }
//                print("Message: \(complexMessage.Message)")
//            }
//            return
//        }
//        
//        // Step 2: Decode to `SimpleMessage`
//        if let simpleMessage = try? decoder.decode(SimpleMessage.self, from: data) {
//            DispatchQueue.main.async {
//                self.currentErrorMessage = simpleMessage.Message
//            }
//            print("Simple Message: \(simpleMessage.Message)")
//            return
//        }
//        
//        // Step 3: Handle unknown message
//        DispatchQueue.main.async {
//            self.currentErrorMessage = "Unknown message format: \(message)"
//        }
//        print("Unknown message format: \(message)")
//    }
//    
//    // MARK: - Đóng WebSocket
//    func closeWebSocket() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//        webSocketTask = nil
//        isConnected = false
//        print("WebSocket connection closed")
//    }
//}
//
