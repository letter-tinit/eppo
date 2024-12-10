//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import Combine
import Alamofire

class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var plants: [Plant] = []
    @Published var hirePlants: [Plant] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isLastPage = false
    @Published var isLastHirePage = false
    @Published var isBuyDataLoaded = false
    @Published var isHireDataLoaded = false
    @Published var recomendOption: RecomendOption = .forBuy
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var currentHirePage = 1

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
    
    func loadMorePlants() {
        guard !isLoading, !isLastPage else { return } // Prevent multiple loading
        isLoading = true
        
        APIManager.shared.getPlantByType(pageIndex: self.recomendOption == .forBuy ? currentPage : currentHirePage, pageSize: 10 , typeEcommerceId: self.recomendOption == .forBuy ? 1 : 2)
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
                
                switch self.recomendOption {
                case .forBuy:
                    if plants.isEmpty {
                        self.isLastPage = true // No more data to load
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.plants.append(contentsOf: plants) // Append new data
                        }
                        self.currentPage += 1 // Increment page for next load
                    }
                    self.isBuyDataLoaded = true
                case .forHire:
                    if plants.isEmpty {
                        self.isLastHirePage = true // No more data to load
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.hirePlants.append(contentsOf: plants) // Append new data
                        }
                        self.currentHirePage += 1 // Increment page for next load
                    }
                    self.isHireDataLoaded = true
                }
            })
            .store(in: &cancellables)
    }
    
    func resetPagination() {
        switch recomendOption {
        case .forBuy:
            DispatchQueue.main.async { [weak self] in
                self?.plants.removeAll()
            }
            currentPage = 1
            isLastPage = false
        case .forHire:
            DispatchQueue.main.async { [weak self] in
                self?.hirePlants.removeAll()
            }
            currentHirePage = 1
            isLastHirePage = false
        }
    }
}
