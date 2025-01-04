//
//  ShopPlantViewModel.swift
//  Eppo
//
//  Created by Treasure Letter on 04/01/2025.
//

import Foundation
import Combine
import Observation

enum PlantTypeSelection: String, CaseIterable {
    case buy = "Bán"
    case hire = "Cho thuê"
}

protocol ShopPlantViewModelProtocol {
    var userName: String { get }
    var imageUrl: String { get }
    var plants: [Plant] { get set }
    var hirePlants: [Plant] { get set }
    var isLoading: Bool { get }
    var plantTypeSelection: PlantTypeSelection { get set }
    func getPlants()
}

@Observable
class ShopPlantViewModel: ShopPlantViewModelProtocol {
    var userName: String
    var imageUrl: String
    var code: String
    var plants: [Plant] = []
    var hirePlants: [Plant] = []
    var isLoading = true
    
    var plantTypeSelection: PlantTypeSelection = .buy
    
    var cancellables: Set<AnyCancellable> = []
    
    init(userName: String, imageUrl: String, code: String) {
        self.userName = userName
        self.imageUrl = imageUrl
        self.code = code
    }
    
    func getPlants() {
        switch plantTypeSelection {
        case .buy:
            getSalePlants()
        case .hire:
            getRentalPlants()
        }
    }
    
    func getSalePlants() {
        isLoading = true
        
        APIManager.shared.getSalePlantByCode(pageIndex: 1, pageSize: 999, code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.plants.removeAll()
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] responseData in
                let plants = responseData.data
                
                print(plants.map { $0.name }.joined(separator: ", "))
                self?.plants = plants
            })
            .store(in: &cancellables)
    }
    
    func getRentalPlants() {
        isLoading = true
        
        APIManager.shared.getRentalPlantByCode(pageIndex: 1, pageSize: 999, code: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.hirePlants.removeAll()
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] responseData in
                let plants = responseData.data
                
                print(plants.map { $0.name }.joined(separator: ", "))
                self?.hirePlants = plants
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
}
