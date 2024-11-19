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
    
    func getRegistedAuctionRoomById(userRoomId: Int) {
        self.isLoading = true
        APIManager.shared.getRegistedAuctonById(userRoomId: userRoomId)
            .timeout(12, scheduler: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
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
