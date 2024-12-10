//
//  AuctionRoomDetailViewModel.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import Foundation
import Observation
import Combine

enum WebSocketStatus: String {
    case connecting = "Đang kết nối"
    case connected = "Đã kết nối"
    case disconnected = "Mất kết nối"
}

@Observable
class AuctionRoomDetailViewModel: ObservableObject {
    var registedRoomResponseData: RegistedRoomResponseData?
    let myInfor: User
    var cancellables: Set<AnyCancellable> = []
    
    var starTimeRemaining: Int = 0
    var endTimeRemaining: Int = 0
    var recommendAuctionNext: Double = 0
    
    // Trạng thái cho UI
    var isLoading = false
    var hasError = false
    var errorMessage: String?
    var isAuctionFinish: Bool = false

    var isShowingAlert: Bool = false
    
    // MARK: - Websocket
    let roomId: Int
    let token: String
    private var webSocketTask: URLSessionWebSocketTask?
    var receivedMessages: [String] = []
    var currentErrorMessage: String?
    var bidhistories: [BidHistory] = []
    var historyBids: [HistoryBid] = []
    var isConnected = false
    var webSocketState: WebSocketStatus = .disconnected
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    
    init(roomId: Int) {
        self.roomId = roomId
        if let token = UserSession.shared.token {
            self.token = token
        } else {
            self.token = "NO_TOKEN"
        }
        
        if let myInfor = UserSession.shared.myInformation {
            self.myInfor = myInfor
        } else {
            self.myInfor = User(userId: 0, userName: "Lỗi", fullName: "Lỗi", gender: "Nam", dateOfBirth: Date(), phoneNumber: "0", email: "Lỗi", identificationCard: "Lỗi")
        }
        
    }
    
    func getRegistedAuctionRoomById() {
        self.isLoading = true
        APIManager.shared.getRegistedAuctonById(roomId: roomId)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.hasError = true
                    self.errorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { registedRoomResponse in
                self.registedRoomResponseData = registedRoomResponse.data
                self.starTimeRemaining = registedRoomResponse.data.openingCoolDown
                self.endTimeRemaining = registedRoomResponse.data.closingCoolDown
                
                if self.starTimeRemaining <= 0{
                    self.startAuction()
                }
                
                if self.endTimeRemaining <= 0{
                    self.finishAuction()
                }
            }
            .store(in: &cancellables)
    }
    
    func getHistoryBids() {
        isLoading = true
        
        APIManager.shared.getHistoryBid(pageIndex: 1, pageSize: 999, roomId: roomId)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { auctionDetailHistoryResponse in
                self.bidhistories = auctionDetailHistoryResponse.data
                self.recommendAuctionNext = auctionDetailHistoryResponse.priceAuctionNext
            }
            .store(in: &cancellables)
    }
    
    func startAuction() {
        connectWebSocket()
        isAuctionFinish = false
    }
    
    func finishAuction() {
        closeWebSocket()
        endTimeRemaining = 0
        isAuctionFinish = true
        generateWinnerMessage()
        isShowingAlert = true
    }
    
    func generateWinnerMessage() {
        guard let winner = bidhistories.first else {
            currentErrorMessage = "Phiên đấu giá đã kết thúc, có lỗi xảy ra khi lấy dữ liệu người thắng cuộc"
            return
        }
        
        if winner.userId == myInfor.userId {
            currentErrorMessage = "Phiên đấu giá đã kết thúc, Bạn là người thắng cuộc với mức giá \(winner.bidAmount)"
        } else {
            currentErrorMessage = "Phiên đấu giá đã kết thúc, Người chơi \(winner.userId) là người thắng cuộc với mức giá \(winner.bidAmount)"
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}


// MARK: - Websocket extension
extension AuctionRoomDetailViewModel {
    
    // MARK: - Kết Nối WebSocket
    func connectWebSocket() {
        webSocketState = .connecting
        
        guard let url = URL(string: "wss://sep490ne-001-site1.atempurl.com/ws/auction") else {
            print("Invalid WebSocket URL")
            webSocketState = .disconnected
            isConnected = false
            return
        }
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume() // Bắt đầu kết nối
        
        // Gửi token xác thực sau khi kết nối
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.sendAuthMessage()
        }
        
        receiveMessage() // Lắng nghe tin nhắn
    }
    
    // MARK: - Gửi Token Xác Thực
    func sendAuthMessage() {
        guard let webSocketTask = webSocketTask else {
            print("WebSocket task is not initialized")
            webSocketState = .disconnected
            isConnected = false
            return
        }
        
        let authMessage: [String: Any] = ["Token": token, "RoomId": roomId]
        guard let authData = try? JSONSerialization.data(withJSONObject: authMessage),
              let authString = String(data: authData, encoding: .utf8) else {
            print("Failed to serialize auth message")
            webSocketState = .disconnected
            isConnected = false
            return
        }
        
        webSocketTask.send(.string(authString)) { error in
            if let error = error {
                print("Error sending auth message: \(error)")
                self.webSocketState = .disconnected
                self.isConnected = false
            } else {
                print("Authentication message sent successfully")
                self.isConnected = true
                self.webSocketState = .connected
            }
        }
    }
    
    // MARK: - Gửi Tin Nhắn
    func sendMessage(bidAmount: Int) {
        guard starTimeRemaining <= 0 else {
            self.currentErrorMessage = "Phiên đấu giá chưa bắt đầu"
            self.isShowingAlert = true
            return
        }
        
        guard isConnected else {
            print("Socket is not connected")
            self.currentErrorMessage = "Bạn bị mất kết nối"
            self.isShowingAlert = true
            self.handleReconnection() // Try to reconnect if not connected
            return
        }
        
        let message: [String: Any] = [
            "RoomId": roomId,
            "BidAmount": bidAmount
        ]
        guard let messageData = try? JSONSerialization.data(withJSONObject: message),
              let messageString = String(data: messageData, encoding: .utf8) else {
            print("Failed to serialize message")
            return
        }
        
        webSocketTask?.send(.string(messageString)) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully")
            }
        }
    }
    
    // MARK: - Nhận Tin Nhắn
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.receivedMessages.append(text)
                        print("Received message: \(text)")
                        self?.processReceivedMessage(text)
                    }
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self?.receivedMessages.append(text)
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
                self?.webSocketState = .disconnected
                self?.handleReconnection()
            }
            
            // Tiếp tục lắng nghe
            self?.receiveMessage()
        }
    }
    
    // MARK: - Xử Lý Kết Nối Lại
    private func handleReconnection() {
        guard reconnectAttempts < maxReconnectAttempts else {
            print("Max reconnection attempts reached")
            return
        }
        
        reconnectAttempts += 1
        print("Attempting to reconnect (\(reconnectAttempts)/\(maxReconnectAttempts))...")
        
        closeWebSocket()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.connectWebSocket()
        }
    }
    
    // MARK: - Xử lý Tin Nhắn Nhận Được
    private func processReceivedMessage(_ message: String) {
        // Case 1: Token
        if message == "Token" {
            DispatchQueue.main.async {
                // DO NOTHING
            }
            print("Authentication successful")
            return
        }
        
        // Case 2: Giá cao hơn giá cao nhất + bước giá
        if message.contains("Bạn phải ra giá cao hơn giá cao nhât") {
            DispatchQueue.main.async {
                self.currentErrorMessage = message
                self.isShowingAlert = true
            }
            print("Bid error: \(message)")
            return
        }
        
        if message.contains("Bạn phải ra giá cao hơn giá khởi điểm") {
            DispatchQueue.main.async {
                self.currentErrorMessage = message
                self.isShowingAlert = true
            }
            print("Bid error: \(message)")
            return
        }
        
        if message.contains(("Có lượt đặt cược mới")){
            DispatchQueue.main.async {
                self.getHistoryBids()
            }
            print("Bid error: \(message)")
            return
        }
        
        if message.contains("Đặt cược thành công") {
            DispatchQueue.main.async {
                self.currentErrorMessage = message
                self.isShowingAlert = true
                self.getHistoryBids()
            }
            print("Bid error: \(message)")
            return
        }
        
//        // Case 3: JSON nội dung đấu giá mới
//        if message.starts(with: "{") && message.contains("\"Message\"") {
//            if let historyBid = decodeHistoryBid(from: message) {
//                print("Decoded HistoryBid: \(historyBid)")
//            } else {
//                print("Decode thất bại")
//            }
//        }
        
        // Case 4: Số dư không đủ
        if message.contains("Số dư ví không đủ") {
            DispatchQueue.main.async {
                self.currentErrorMessage = message
                self.isShowingAlert = true
            }
            print("Balance error: \(message)")
            return
        }
        
        // Unknown message
        DispatchQueue.main.async {
            self.currentErrorMessage = "Unknown message format: \(message)"
        }
        print("Unknown message format: \(message)")
    }
    
    func decodeHistoryBid(from jsonString: String) -> HistoryBid? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Lỗi khi chuyển chuỗi thành Data")
            return nil
        }
        
        do {
            let rootResponse = try JSONDecoder().decode(RootResponse.self, from: jsonData)
            return rootResponse.historyBid
        } catch {
            print("Lỗi decode JSON: \(error)")
            return nil
        }
    }
    
    // MARK: - Đóng WebSocket
    func closeWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
        webSocketState = .disconnected
        print("WebSocket connection closed")
    }
}
