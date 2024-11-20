//
//  AuctionRoomDetailViewModel.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class AuctionRoomDetailViewModel {
    var registedRoomResponseData: RegistedRoomResponseData?
    
    var cancellables: Set<AnyCancellable> = []
    
    var starTimeRemaining: Int?
    var endTimeRemaining: Int = 0
    
    // Trạng thái cho UI
    var isLoading = false
    var hasError = false
    var errorMessage: String?
    
    func getRegistedAuctionRoomById(roomId: Int) {
        self.isLoading = true
        APIManager.shared.getRegistedAuctonById(roomId: roomId)
            .timeout(.seconds(10), scheduler: DispatchQueue.main)
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
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
