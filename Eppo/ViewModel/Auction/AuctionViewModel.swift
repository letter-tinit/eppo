//
//  AuctionViewModel.swift
//  Eppo
//
//  Created by Letter on 09/11/2024.
//

import Foundation
import Combine
import Observation

@Observable class AuctionViewModel {
    var rooms: [Room] = []
    var isLastPage: Bool = false
    var isLoading: Bool = false
    var currentPage: Int = 1
    var isEmptyResult = false
    var selectedDate: Date?
    
    var cancellables: Set<AnyCancellable> = []
    
    func loadMoreAutionRooms() {
        guard !isLoading, !isLastPage else { return }
        
        isLoading = true
        APIManager.shared.getListAuctionRoom(pageIndex: currentPage, pageSize: 10)
            .sink { result in
                self.isLoading = false
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { auctionResponse in
                if auctionResponse.data.isEmpty {
                    self.isLastPage = true
                } else {
                    self.rooms.append(contentsOf: auctionResponse.data)
                    self.currentPage += 1
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreAuctiuonRoomsByDate() {
        guard let selectedDate = self.selectedDate, !isLoading else { return }
        
        isLoading = true
        APIManager.shared.getListAuctionRoomByDate(pageIndex: 1, pageSize: 100, date: reformatDateStringToPassing(selectedDate))
            .sink { result in
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .dataNotFound:
                            self.rooms.removeAll()
                            self.isEmptyResult = true
                            self.isEmptyResult = true
                            print("Error: Data not found for the specified date.")
                        case .failedToGetData:
                            print("Error: Failed to retrieve auction data.")
                        default:
                            print("Error: \(apiError.localizedDescription)")
                        }
                    } else {
                        // Generic error case
                        print("Unknown error: \(error.localizedDescription)")
                    }
                }
            } receiveValue: { auctionResponse in
                self.rooms = auctionResponse.data
                self.isEmptyResult = false
            }
            .store(in: &cancellables)
    }
    
    func resetAllPage() {
        currentPage = 1
        rooms.removeAll()
        isLastPage = false
        isEmptyResult = false
    }
    
    func reformatDateStringToPassing(_ date: Date) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        return outputFormatter.string(from: date)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
