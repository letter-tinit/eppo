//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import Combine
import Alamofire

class HomeViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isLastPage = false
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    func getPlantByType(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) {
        APIManager.shared.getPlantByType(pageIndex: pageIndex, pageSize: pageSize, typeEcommerceId: typeEcommerceId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { responseData in
                let plants = responseData.data
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
            }, receiveValue: { responseData in
                let plants = responseData.data
                
                print(plants.map { $0.name }.joined(separator: ", "))

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
