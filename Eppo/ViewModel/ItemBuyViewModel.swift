//
//  ItemBuyViewModel.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation
import Combine

class ItemBuyViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var plants: [Plant] = []
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isCategoriesLoading: Bool = false
    @Published var isLastPage = false
    @Published var isEmptyResult: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    func loadMorePlants(typeEcommerceId: Int) {
        guard !isLoading, !isLastPage else { return }
        
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
                
                self.isEmptyResult = !self.isLoading && self.plants.isEmpty
            })
            .store(in: &cancellables)
    }
    
    func resetPagination() {
        plants.removeAll()
        currentPage = 1
        isLastPage = false
    }
    
    func getListCategory() {
        isCategoriesLoading = true
        APIManager.shared.getListCategory(token: UserSession.shared.token ?? "")
            .sink { result in
                switch result {
                case .finished:
                    self.isCategoriesLoading = false
                    break
                case .failure(let error):
                    self.isCategoriesLoading = false
                    print(error.localizedDescription)
                }
            } receiveValue: { categoryResponse in
                self.categories = categoryResponse.data
            }
            .store(in: &cancellables)
        
    }
    
    func loadMorePlantsForCate(typeEcommerceId: Int) {
        guard !isLoading, !isLastPage else { return } // Prevent multiple loading
        
        isLoading = true
        APIManager.shared.getPlantByTypeAndCate(pageIndex: currentPage, pageSize: 10 , typeEcommerceId: typeEcommerceId, categoryId: self.selectedCategory?.categoryId ?? 0)
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
                    self.isLastPage = true
                } else {
                    self.plants.append(contentsOf: plants)
                    self.currentPage += 1
                }
                
                self.isEmptyResult = !self.isLoading && self.plants.isEmpty
            })
            .store(in: &cancellables)
    }
}
