//
//  FeedBackViewModel.swift
//  Eppo
//
//  Created by Letter on 28/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class FeedBackViewModel {
    var plants: [Plant] = []
    var cancellables: Set<AnyCancellable> = []
    var isLoading = false
    var isAlertShowing: Bool = false
    var errorMessage: String?
    
    func getFeedBackOrder() {
        APIManager.shared.getFeedBackOrder(pageIndex: 1, pageSize: 999)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self.plants = []
                }
            } receiveValue: { buyHistoryResponse in
                print(buyHistoryResponse)
                self.plants = buyHistoryResponse.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach {$0.cancel()}
    }
}
