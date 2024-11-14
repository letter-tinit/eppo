//
//  ItemDetailsViewModel.swift
//  Eppo
//
//  Created by Letter on 06/11/2024.
//

import Foundation
import Combine
import Observation

enum ActiveAlert {
    case first, second
}

@Observable class ItemDetailsViewModel {
    var plant: Plant?
    var isAlertShowing: Bool = false
    
    var message: String = ""
    
    var isLoading: Bool = false
    
    // MARK: - HireItemDetailScreen
    var selectedDate = Date()
    var numberOfMonth = 1
    let step = 1
    let range = 1...99
    var deliveriteFree: Double?
    var contractNumber: Int?
    var contractId: Int?
    var contractUrl: String?
    var isSigned: Bool = false
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
            } receiveValue: { plantResponse in
                self.plant = plantResponse.data
            }
            .store(in: &cancellables)
    }
    
    // MARK: - HireItemDetailScreen
    
    func createOrderRental(paymentId: Int) {
        self.deliveriteFree = 0
        guard let plant = self.plant,
        let deliveriteFree = self.deliveriteFree else {
            return
        }
        
        let order = Order(
            totalPrice: rentTotalPrice(),
            deliveryFee: deliveriteFree,
            deliveryAddress: "Thành Phố Hồ Chí Minh",
            paymentId: paymentId,
            orderDetails: [
                OrderDetail(plantId: plant.id,
                            rentalStartDate: Date(),
                            numberMonth: numberOfMonth)
            ]
        )
        
        APIManager.shared.createOrderRental(order: order)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { orderResponse in
                self.contractNumber = orderResponse.data.orderId
                self.createContract()
            }
            .store(in: &cancellables)
    }
    
    func createContract() {
        guard let plant = self.plant,
              let contractNumber = self.contractNumber
        else {
            return
        }
        
        let contractDetails = [
            ContractDetail(plantId: plant.id, totalPrice: rentTotalPrice())
        ]
        
        let contractRequest = ContractRequest(
            contractNumber: contractNumber,
            description: "Cho thuê \(plant.name)",
            creationContractDate: Date(),
            endContractDate: Date(),
            totalAmount: rentTotalAmount(),
            contractDetails: contractDetails
        )
        
        APIManager.shared.createContract(createContractRequest: contractRequest)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractId = contractResponse.contractId
            }
            .store(in: &cancellables)
    }
    
    func getContractById() {
        guard let contractId = self.contractId else {
            return
        }
        
        APIManager.shared.getContractById(contractId: contractId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { contractResponse in
                print(contractResponse)
                self.contractUrl = contractResponse.data.contractUrl
            }
            .store(in: &cancellables)

    }
    
    func rentTotalAmount() -> Double {
        return ((self.plant?.price ?? 0) * Double(self.numberOfMonth)) + (self.deliveriteFree ?? 0)
    }
    
    func rentTotalPrice() -> Double {
        return ((self.plant?.price ?? 0) * Double(self.numberOfMonth)) + (self.deliveriteFree ?? 0)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
