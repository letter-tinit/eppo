//
//  AuctionRoomViewModel.swift
//  Eppo
//
//  Created by Letter on 18/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class AuctionRoomViewModel {
    var userRooms: [UserRoom] = []
    
    var registedRoomResponseData: RegistedRoomResponseData?
    
    var cancellables: Set<AnyCancellable> = []
    
    // Trạng thái cho UI
    var isLoading = false
    var hasError = false
    var errorMessage: String?
    
    func getListRegistedAuctionRoom() {
        isLoading = true
        hasError = false
        errorMessage = nil
        
        APIManager.shared.getListRegisteredAuction(pageIndex: 1, pageSize: 999)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.userRooms.removeAll()
                    print(error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { registeredRoomsResponse in
                self.userRooms = registeredRoomsResponse.data
            }
            .store(in: &cancellables)
    }
    
    func getRegistedAuctionRoomById(roomId: Int) {
        APIManager.shared.getRegistedAuctonById(roomId: roomId)
            .timeout(.seconds(10), scheduler: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { registedRoomResponse in
                self.registedRoomResponseData = registedRoomResponse.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
