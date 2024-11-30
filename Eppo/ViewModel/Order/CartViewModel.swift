//
//  OrderDetailsswift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import Foundation
import Combine
import Observation

@Observable class CartViewModel {
    var createOrderRequest: CreateOrderRequest?
    var addresses: [Address] = []
    var selectedAddress: Address?
    var cancellables: Set<AnyCancellable> = []
    var isCreateSucces: Bool = false
    var isLoading: Bool = false
    var message: String = ""
    var isAlertShowing: Bool = false
    var totalShippingFee = 0.0
    var selectedCart: CartState = .buy
    
    
    var orderDetails: [Plant]
    var selectedOrder: [Plant] = []
    var allItemsSelected: Bool {
        orderDetails.allSatisfy { $0.isSelected }
    }
    
    var hireOrderDetails: [Plant]
    var selectedHireOrder: [Plant] = []
    var allHireItemsSelected: Bool {
        hireOrderDetails.allSatisfy { $0.isSelected }
    }
    
    var selectedDate = Date()
    var numberOfMonth: Int = 1
    let step = 1
    let range = 1...99
    var contractNumber: Int?
    var contractId: Int?
    var contractUrl: String?
    var isSigned: Bool = false
    var isLinkActive = false
    
    init() {
        self.orderDetails = UserSession.shared.cart
        self.hireOrderDetails = UserSession.shared.hireCart
    }
    
    func createOrder() {
        isLoading = true
        
        guard var createOrderRequest = self.createOrderRequest,
              let addressDescription = self.selectedAddress?.description else {
            return
        }
        
        createOrderRequest.deliveryAddress = addressDescription
        
        APIManager.shared.createOrder(createOrderRequest: createOrderRequest)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Thực thi thành công")
                    UserSession.shared.cart.removeAll { parent in
                        self.selectedOrder.contains { child in
                            child.id == parent.id
                        }
                    }

                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                print(response)
                self.message = response.message
                self.isAlertShowing = true
            })
            .store(in: &cancellables)
    }
    
    func getShippingFeeByPlantId(plantId: Int, completion: @escaping (Result<Double, Error>) -> Void) {
        APIManager.shared.getShippingFee(plantId: plantId)
            .sink { completionEvent in
                switch completionEvent {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error)) // Pass the error to the completion handler
                }
            } receiveValue: { shippingFeeResponse in
                completion(.success(shippingFeeResponse.data))            }
            .store(in: &cancellables)
    }

    func getAddress() {
        isLoading = true
        
        APIManager.shared.getAddress()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { addressResponse in
                self.addresses = addressResponse.data
                self.selectedAddress = addressResponse.data.first
            }
            .store(in: &cancellables)
    }

    // MARK: - FUNCTIONS
    
    func deleteItem(at offsets: IndexSet) {
        UserSession.shared.cart.remove(atOffsets: offsets)
        orderDetails.remove(atOffsets: offsets)
        print("Order details")
        print(orderDetails)
        print("SessionCart details")
        print(UserSession.shared.cart)
    }
    
    func deleteHireItem(at offsets: IndexSet) {
        UserSession.shared.hireCart.remove(atOffsets: offsets)
        hireOrderDetails.remove(atOffsets: offsets)
        print("Order details")
        print(orderDetails)
        print("SessionCart details")
        print(UserSession.shared.cart)
        
        print("Hire Order details")
        print(hireOrderDetails)
        print("Hire SessionCart details")
        print(UserSession.shared.hireCart)
    }
    
    func toggleAllSelections() {
        let shouldSelectAll = !allItemsSelected
        orderDetails = orderDetails.map { plant in
            var updatedPlant = plant
            updatedPlant.isSelected = shouldSelectAll
            return updatedPlant
        }
    }
    
    func toggleAllHireSelections() {
        let shouldSelectAll = !allHireItemsSelected
        hireOrderDetails = hireOrderDetails.map { plant in
            var updatedPlant = plant
            updatedPlant.isSelected = shouldSelectAll
            return updatedPlant
        }
    }
    
    func totalPrice() -> Double {
        return orderDetails
            .filter { $0.isSelected }
            .map { $0.finalPrice }
            .reduce(0, +)
    }
    
    func totalRentalPrice() -> Double {
        return hireOrderDetails
            .filter { $0.isSelected }
            .map { $0.finalPrice * Double(numberOfMonth) }
            .reduce(0, +)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
