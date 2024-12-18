//
//  AuctionDetailsViewModel.swift
//  Eppo
//
//  Created by Letter on 10/11/2024.
//

import Foundation
import Observation
import Combine

@Observable class AuctionDetailsViewModel {
    var room: Room?
    var registedNumber: Int = 0
    var opeiningCooldown: Int = 1
    var message: String? {
        didSet {
            isAlertShowing = message != nil
        }
    }

    var isAlertShowing: Bool = false

    var cancellables: Set<AnyCancellable> = []
    var isRegisted: Bool = false
    
    // MARK: - UILOADING
    var isLoading = false
    var hasError = false
    var isSucessRegisted = false
    
    func getRoomById(roomId: Int) {
        isLoading = true
        hasError = false
        
        APIManager.shared.getRoomById(id: roomId)
            .sink { result in
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.hasError = true
                    print(error.localizedDescription)
                }
            } receiveValue: { auctionDetailResponse in
                self.room = auctionDetailResponse.data.room
                self.registedNumber = auctionDetailResponse.data.registeredCount
                self.opeiningCooldown = auctionDetailResponse.data.openingCoolDown
                if let userRoom = auctionDetailResponse.data.room.userRooms.first {
                    if let isActive = userRoom?.isActive {
                        self.isRegisted = isActive
                    }
                } else {
                    self.isRegisted = false
                }
            }
            .store(in: &cancellables)
    }
    
    func auctionRegistration() {
        guard let room = room else {
            return
        }
        
        APIManager.shared.auctionRegistration(roomId: room.roomId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.message = "Đăng ký thành công"
                    self.isSucessRegisted = true
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.message = error.localizedDescription
                }
            } receiveValue: {}
            .store(in: &cancellables)
        
    }
    
    deinit {
        cancellables.removeAll()
    }
}

