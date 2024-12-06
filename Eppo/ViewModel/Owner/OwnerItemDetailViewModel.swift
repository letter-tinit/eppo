//
//  OwnerItemDetailViewModel.swift
//  Eppo
//
//  Created by Letter on 03/12/2024.
//

import Foundation
import Combine
import Observation

@Observable
class OwnerItemDetailViewModel {
    var feedBacks: [FeedBack] = []
    var averageRating: Double = 0
    var numberOfFeedbacks = 0
    private var cancellables = Set<AnyCancellable>()

    func getFeedbacks(plantId: Int) {
        APIManager.shared.plantFeedBack(pageIndex: 1, pageSize: 999, plantId: plantId)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.feedBacks.removeAll()
                }
            } receiveValue: { [weak self] feedBackAPIResponse in
                self?.averageRating = feedBackAPIResponse.data.totalRating / Double(feedBackAPIResponse.data.numberOfFeedbacks)
                self?.numberOfFeedbacks = feedBackAPIResponse.data.numberOfFeedbacks
                self?.feedBacks = feedBackAPIResponse.data.feedbacks
                print(self?.feedBacks as Any)
            }
            .store(in: &cancellables)
        
    }
}
