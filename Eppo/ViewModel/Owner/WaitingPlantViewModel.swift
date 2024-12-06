//
//  WaitingPlantViewModel.swift
//  Eppo
//
//  Created by Letter on 03/12/2024.
//

import Foundation
import Combine
import Observation

enum PlantStatus: String, CaseIterable {
    case pendingApproval = "Chờ xét duyệt"
    case approvalFailed = "Duyệt thất bại"
}

@Observable
class WaitingPlantViewModel {
    var plants: [Plant] = []
    
    var selectedPlantStatus: PlantStatus = .pendingApproval
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Binding
    var isLoading = false
    var hasError = false
    
    func getPlants() {
        plants.removeAll()
        switch selectedPlantStatus {
        case .approvalFailed:
            getApprovalFailed()
        case .pendingApproval:
            getPendingApproval()
        }
    }
    
    func getPendingApproval() {
        APIManager.shared.getWaitToAcceptPlant(pageIndex: 1, pageSize: 999)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.plants.removeAll()
                    print(error.localizedDescription)
                    self?.hasError = true
                }
            } receiveValue: {[weak self] response in
                self?.plants = response.data
            }
            .store(in: &cancellables)
    }
    
    func getApprovalFailed() {
        APIManager.shared.getUnAcceptPlant(pageIndex: 1, pageSize: 999)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.plants.removeAll()
                    print(error.localizedDescription)
                    self?.hasError = true
                }
            } receiveValue: {[weak self] response in
                self?.plants = response.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
