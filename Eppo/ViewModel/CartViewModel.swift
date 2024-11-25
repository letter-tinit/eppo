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
    
    
    var orderDetails: [Plant]
    var selectedOrder: [Plant] = []
    var allItemsSelected: Bool {
        orderDetails.allSatisfy { $0.isSelected }
    }
    
    init() {
        self.orderDetails = UserSession.shared.cart
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
                    self.message = "Tạo đơn hàng thành công"
                    self.isAlertShowing = true
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
            }, receiveValue: { statusCode, message in
                print(message)
            })
            .store(in: &cancellables)
    }
    
//    func getShippingFeeByPlantId(plantId: Int) -> Double {
//        APIManager.shared.getShippingFee(plantId: plantId)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { shippingFeeResponse in
//                return shippingFeeResponse.data
//            }
//            .store(in: &cancellables)
//    }
    
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
    
    func toggleAllSelections() {
        let shouldSelectAll = !allItemsSelected
        orderDetails = orderDetails.map { plant in
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
    
    deinit {
        cancellables.removeAll()
    }
}
