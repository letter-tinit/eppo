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
    var plants: [Plant] { get set }
    var hirePlants: [Plant] { get set }
    var isLoading: Bool { get }
    var plantTypeSelection: PlantTypeSelection { get set }
    func getPlants()
}

@Observable
class ShopPlantViewModel: ShopPlantViewModelProtocol {
    var plants: [Plant] = []
    var hirePlants: [Plant] = []
    var isLoading = true
    
    var plantTypeSelection: PlantTypeSelection = .buy
    
    var cancellables: Set<AnyCancellable> = []
    
    func getPlants() {
        isLoading = true
        
        APIManager.shared.getPlantByType(pageIndex: 1, pageSize: 999, typeEcommerceId: plantTypeSelection == .buy ? 1 : 2)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.plants.removeAll()
                    self?.hirePlants.removeAll()
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] responseData in
                let plants = responseData.data
                
                print(plants.map { $0.name }.joined(separator: ", "))
                
                switch self?.plantTypeSelection {
                case .buy:
                    self?.plants = plants

                case .hire:
                    self?.hirePlants = plants
                    
                case nil:
                    self?.plants.removeAll()
                    self?.hirePlants.removeAll()
                }
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
}
