//
//  OrderDetailsswift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import Foundation
import Combine
import Observation

@Observable 
class CartViewModel {
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
        createOrderRequest.deliveryFee = totalShippingFee
        
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
                completion(.success(shippingFeeResponse.data))
            }
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
    
    func getSamplePlants() -> [Plant] {
        return [
            Plant(id: 1,
                  name: "Aloe Vera",
                  title: "Aloe Vera Succulent Plant",
                  finalPrice: 14.99,
                  description: "Aloe Vera is known for its soothing properties and is commonly used in skincare products. It’s easy to care for and can grow in most environments.",
                  mainImage: "https://example.com/images/aloe_vera_main.jpg",
                  imagePlants: [
                    ImagePlantResponse(id: 1, imageUrl: "https://example.com/images/aloe_vera_1.jpg"),
                    ImagePlantResponse(id: 2, imageUrl: "https://example.com/images/aloe_vera_2.jpg")
                  ],
                  status: 1,
                  isActive: true,
                  typeEcommerceId: 101),
            
            Plant(id: 2,
                  name: "Snake Plant",
                  title: "Sansevieria Snake Plant",
                  finalPrice: 19.99,
                  description: "The Snake Plant is a resilient plant known for its air-purifying abilities and low maintenance. Perfect for any indoor space.",
                  mainImage: "https://example.com/images/snake_plant_main.jpg",
                  imagePlants: [
                    ImagePlantResponse(id: 1, imageUrl: "https://example.com/images/snake_plant_1.jpg"),
                    ImagePlantResponse(id: 2, imageUrl: "https://example.com/images/snake_plant_2.jpg")
                  ],
                  status: 1,
                  isActive: true,
                  typeEcommerceId: 102),
            
//            Plant(id: 3,
//                  name: "Spider Plant",
//                  title: "Chlorophytum Spider Plant",
//                  finalPrice: 12.50,
//                  description: "The Spider Plant is an easy-to-grow indoor plant known for its air-purifying qualities and its ability to propagate with ease.",
//                  mainImage: "https://example.com/images/spider_plant_main.jpg",
//                  imagePlants: [
//                    ImagePlantResponse(id: 1, imageUrl: "https://example.com/images/spider_plant_1.jpg"),
//                    ImagePlantResponse(id: 2, imageUrl: "https://example.com/images/spider_plant_2.jpg")
//                  ],
//                  status: 1,
//                  isActive: true,
//                  typeEcommerceId: 103),
//            
//            Plant(id: 4,
//                  name: "Peace Lily",
//                  title: "Spathiphyllum Peace Lily",
//                  finalPrice: 29.99,
//                  description: "The Peace Lily is a popular houseplant known for its beautiful white flowers and air-purifying properties. It thrives in low light and is easy to care for.",
//                  mainImage: "https://example.com/images/peace_lily_main.jpg",
//                  imagePlants: [
//                    ImagePlantResponse(id: 1, imageUrl: "https://example.com/images/peace_lily_1.jpg"),
//                    ImagePlantResponse(id: 2, imageUrl: "https://example.com/images/peace_lily_2.jpg")
//                  ],
//                  status: 1,
//                  isActive: true,
//                  typeEcommerceId: 104),
            
            Plant(id: 5,
                  name: "Fiddle Leaf Fig",
                  title: "Ficus Lyrata Fiddle Leaf Fig",
                  finalPrice: 49.99,
                  description: "The Fiddle Leaf Fig is a stunning ornamental plant with large, glossy leaves. It’s ideal for adding a tropical touch to your home or office.",
                  mainImage: "https://example.com/images/fiddle_leaf_fig_main.jpg",
                  imagePlants: [
                    ImagePlantResponse(id: 1, imageUrl: "https://example.com/images/fiddle_leaf_fig_1.jpg"),
                    ImagePlantResponse(id: 2, imageUrl: "https://example.com/images/fiddle_leaf_fig_2.jpg")
                  ],
                  status: 1,
                  isActive: true,
                  typeEcommerceId: 105)
        ]
    }

    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
