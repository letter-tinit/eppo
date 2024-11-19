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
    var message: String? {
        didSet {
            isAlertShowing = message != nil
        }
    }

    var isAlertShowing: Bool = false

    var cancellables: Set<AnyCancellable> = []
    
    func getRoomById(roomId: Int) {
        APIManager.shared.getRoomById(id: 10)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { auctionDetailResponse in
                self.room = auctionDetailResponse.data
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

