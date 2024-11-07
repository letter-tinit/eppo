//
//  ItemDetailsViewModel.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation
import Combine

class ItemDetailsViewModel: ObservableObject {
    @Published var plant: Plant?
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func getPlantById(id: Int) {
        self.isLoading = true
        
        APIManager.shared.getPlantById(id: id)
            .sink { result in
                switch result {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { plant in
                self.plant = plant
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
