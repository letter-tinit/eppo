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
    
    var cancellables: Set<AnyCancellable> = []
    
    func getRoomById(roomId: Int) {
        APIManager.shared.getRoomById(id: roomId)
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
    
    deinit {
        cancellables.removeAll()
    }
}

