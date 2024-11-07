//
//  ItemBuyViewModel.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation
import Combine

class ItemBuyViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isLastPage = false
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    func getPlant(pageIndex: Int, pageSize: Int) {
        APIManager.shared.getPlantByType(pageIndex: pageIndex, pageSize: pageSize, typeEcommerceId: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { plants in
                self.plants = plants
            })
            .store(in: &cancellables)
    }
    
    func loadMorePlants(typeEcommerceId: Int) {
        guard !isLoading, !isLastPage else { return } // Prevent multiple loading
        
        isLoading = true
        APIManager.shared.getPlantByType(pageIndex: currentPage, pageSize: 10 , typeEcommerceId: typeEcommerceId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { plants in
                if plants.isEmpty {
                    self.isLastPage = true // No more data to load
                } else {
                    self.plants.append(contentsOf: plants) // Append new data
                    self.currentPage += 1 // Increment page for next load
                }
            })
            .store(in: &cancellables)
    }
    
    func resetPagination() {
        plants.removeAll()
        currentPage = 1
        isLastPage = false
    }
}
