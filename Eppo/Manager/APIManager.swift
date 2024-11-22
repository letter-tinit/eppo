//
//  APIManager.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

import Foundation
import Alamofire
import Combine
import UIKit
import ImageIO
import UniformTypeIdentifiers

enum APIError: Error {
    case dataNotFound
    case failedToGetData
    case badUrl
    case transportError
    case invalidResponse
    
    // MARK: - NEW CASE
    case networkError
    case serverError(statusCode: Int)
    case decodingError
    case noData
    case custom(message: String)
    case unexpectedError
}

struct APIErrorResponse: Codable, Error {
    let message: String
}

struct APIConstants {
    
    static let baseURL = "https://sep490ne-001-site1.atempurl.com/"
    
    struct Auth {
        static let login = baseURL + "api/v1/Users/Login"
    }
    
    struct Plant {
        static let getByType = baseURL + "api/v1/GetList/Plants/Filter/ByTypeEcommerceId"
        static let getByTypeAndCate = baseURL + "api/v1/GetList/Plants/Filter/TypeEcommerceIdAndCategoryId"
        static let getById = baseURL + "api/v1/Plant/"
        static let createPlant = baseURL + "api/v1/Plants/CreatePlant/ByToken"
    }
    
    struct Room {
        static let getList = baseURL + "api/v1/GetList/Rooms"
        static let getByDate = baseURL + "api/v1/GetList/Rooms/SearchRoomByDate"
        static let getById = baseURL + "api/v1/GetList/Rooms/Id"
        static let auctionRegistration = baseURL + "api/v1/GetList/UserRoom/Create/UserRoom"
        static let getListRegisterdAuctionRoom = baseURL + "api/v1/GetList/UserRoom/Registered/ByToken"
        static let getRegistedAuctionRoomById = baseURL + "api/v1/GetList/UserRoom/RoomId"
        
    }
    
    struct Category {
        static let getList = baseURL + "api/v1/GetList/Categories"
    }
    
    struct Notification {
        static let getList = baseURL + "api/v1/GetList/Notification"
    }
    
    struct Order {
        static let createOrder = baseURL + "api/v1/Order"
        static let createOrderRental = baseURL + "api/v1/Order/CreateOrderRental"
        static let updatePaymentOrderRental = baseURL + "api/v1/Order/UpdatePaymentOrderRental"
        static let getHireOrderHistory = baseURL + "api/v1/Order/GetOrdersRentalByUser"
        static let getBuyOrderHistory = baseURL + "api/v1/Order/GetOrdersBuyByUser"
        static let cancelOrder = baseURL + "api/v1/Order/CancelOrder/"
    }
    
    struct User {
        static let getMyInfor = baseURL + "api/v1/GetUser/Users/Information/UserID"
    }
    
    
    struct Address {
        static let getList = baseURL + "api/v1/GetList/Address/OfByUserID/ByToken"
        static let create = baseURL + "api/v1/GetList/Address/CreateAddress"
        static let delete = baseURL + "api/v1/GetList/Address/Delete/AddressByToken/Id"
    }
    
    struct Contract {
        static let getById = baseURL + "api/v1/GetList/Contracts/Id"
        static let create = baseURL + "api/v1/GetList/Contracts/Create/Contract"
    }
    
    struct Transaction {
        static let getHistory = baseURL + "api/v1/Transaction/GetAllTransactionsInWallet"
    }
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, APIError>  {
        let apiUrl = APIConstants.Auth.login
        
        let parameters = LoginRequest(userName: username, password: password)
        
        return AF.request(apiUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .publishData()
            .tryMap { response in
                // Kiểm tra mã trạng thái HTTP
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200...299:
                        // Nếu mã thành công, trả về dữ liệu thô
                        if let data = response.data {
                            return data
                        } else {
                            throw APIError.noData // Nếu không có dữ liệu, ném lỗi thích hợp
                        }
                    case 400...499:
                        throw APIError.serverError(statusCode: statusCode)
                    case 401:
                        throw APIError.custom(message: "Chưa được xác thực.")
                    case 403:
                        throw APIError.custom(message: "Không có quyền truy cập.")
                    case 404:
                        throw APIError.custom(message: "Không tìm thấy dữ liệu.")
                    case 500...599:
                        throw APIError.serverError(statusCode: statusCode)
                    default:
                        // Lỗi khác
                        throw APIError.unexpectedError
                    }
                } else {
                    throw APIError.networkError
                }
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder()) // Giải mã dữ liệu
            .mapError { error in
                // Chuyển đổi lỗi thành APIError
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.decodingError
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - FIX Get do not contains request body
    func getPlantByType(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.getByType) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "typeEcommerceId", value: String(typeEcommerceId))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getPlantById(id: Int) -> AnyPublisher<PlantResponse, Error> {
        guard let url = URL(string: APIConstants.Plant.getById + String(describing: id)) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .response { response in
                print(response.result as Any)
            }
            .publishDecodable(type: PlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListAuctionRoom(pageIndex: Int, pageSize: Int) -> AnyPublisher<AuctionResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Room.getList) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageIndex)),
            URLQueryItem(name: "size", value: String(pageSize))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: AuctionResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListAuctionRoomByDate(pageIndex: Int, pageSize: Int, date: String) -> AnyPublisher<AuctionResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Room.getByDate) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageIndex)),
            URLQueryItem(name: "size", value: String(pageSize)),
            URLQueryItem(name: "date", value: String(date))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: AuctionResponse.self)
            .value()
            .mapError { error -> APIError in
                if let afError = error.asAFError, afError.responseCode == 404 {
                    return .dataNotFound
                } else {
                    return .failedToGetData
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getRoomById(id: Int) -> AnyPublisher<AuctionDetailResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Room.getById) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "roomId", value: String(id))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: AuctionDetailResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func auctionRegistration(roomId: Int) -> AnyPublisher<Void, Error> {
        let url = APIConstants.Room.auctionRegistration
        
        let parameters: [String: Any] = [
            "roomId": roomId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                guard let error = response.error else {
                    return ()
                }
                
                throw error
            }
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListCategory(token: String) -> AnyPublisher<CategoryResponse, Error> {
        let url = APIConstants.Category.getList
        let parameters: [String: Any] = [
            "page": 1,
            "size": 100
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate() // Validates the response
            .response { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(String(describing: value))") // Print the JSON response to inspect
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                }
            }
            .publishDecodable(type: CategoryResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getPlantByTypeAndCate(pageIndex: Int, pageSize: Int, typeEcommerceId: Int, categoryId: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.getByTypeAndCate) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "typeEcommerceId", value: String(typeEcommerceId)),
            URLQueryItem(name: "categoryId", value: String(categoryId))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListNotifications(token: String, pageIndex: Int, pageSize: Int) -> AnyPublisher<NotificationResponse, Error> {
        let url = APIConstants.Notification.getList
        
        let parameters: [String: Any] = [
            "page": pageIndex,
            "size": pageSize
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate() // Validates the response
            .response { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(String(describing: value))") // Print the JSON response to inspect
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                }
            }
            .publishDecodable(type: NotificationResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func createOrder(createOrderRequest: CreateOrderRequest) -> AnyPublisher<(Int, String), Error> {
        let apiUrl = APIConstants.Order.createOrder
        
        // Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(apiUrl, method: .post, parameters: createOrderRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300) // Validate status code is between 200 and 299
            .publishData() // Use Alamofire's Combine publisher to get the response
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw NSError(domain: "API Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response received"])
                }
                
                // Check if status code is 200 (Success)
                if (200...299).contains(statusCode) {
                    return (statusCode, "Đơn hàng đã đặt thành công")
                }
                
                
                // Check for 500 (Server Error) and get the response message
                if statusCode == 500 {
                    return (500, "Số dư ví hiện không khả dụng")
                }
                
                // For other status codes, throw an error
                throw NSError(domain: "API Error", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error occurred"])
            }
            .mapError { error in
                error // Handle and map error to the Combine error
            }
            .eraseToAnyPublisher() // Return the publisher as AnyPublisher
    }
    
    func getMyInformation() -> AnyPublisher<UserResponse, Error> {
        let apiUrl = APIConstants.User.getMyInfor
        
        // Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        //        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIzIiwicm9sZUlkIjoiNSIsInJvbGVOYW1lIjoiY3VzdG9tZXIiLCJmdWxsTmFtZSI6IlVzZXIgVGhyZWUiLCJlbWFpbCI6ImN1c3RvbWVyQGV4YW1wbGUuY29tIiwicGhvbmVOdW1iZXIiOiIwMTEyMjMzNDQ1IiwiZ2VuZGVyIjoiTWFsZSIsIndhbGxldElkIjoiMiIsImlkZW50aWZpY2F0aW9uQ2FyZCI6IjEyMzQ1NiIsImRhdGVPZkJpcnRoIjoiMy8zLzE5OTQgMTI6MDA6MDAgQU0iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJjdXN0b21lciIsImV4cCI6MTczMTQwMDY0MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTAwMCIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjUwMDAifQ.TFZ_kqsJ27dltRVfud-IJXbhy94SnQIbwMxeDvSKJFE"
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(apiUrl, method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let value):
                    print("Response JSON: \(String(describing: value))") // Print the JSON response to inspect
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                }
            }
            .publishDecodable(type: UserResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getAddress() -> AnyPublisher<AddressResponse, Error> {
        let url = APIConstants.Address.getList
        
        //         Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishData()
            .tryMap { response in
                // Kiểm tra mã trạng thái HTTP
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200...299:
                        // Nếu mã thành công, trả về dữ liệu thô
                        if let data = response.data {
                            return data
                        } else {
                            throw APIError.noData // Nếu không có dữ liệu, ném lỗi thích hợp
                        }
                    case 400...499:
                        throw APIError.serverError(statusCode: statusCode)
                    case 401:
                        throw APIError.custom(message: "Chưa được xác thực.")
                    case 403:
                        throw APIError.custom(message: "Không có quyền truy cập.")
                    case 404:
                        throw APIError.custom(message: "Không tìm thấy dữ liệu.")
                    case 500...599:
                        throw APIError.serverError(statusCode: statusCode)
                    default:
                        // Lỗi khác
                        throw APIError.unexpectedError
                    }
                } else {
                    throw APIError.networkError
                }
            }
            .decode(type: AddressResponse.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.decodingError
                }
            }
            .eraseToAnyPublisher()
    }
    
    func createAddress(createAddressResponse: CreateAddessRequest) -> AnyPublisher<CreateAddressResponse, Error> {
        let apiUrl = APIConstants.Address.create
        
        // Ensure there's a token available
        guard let headers = setupHeaderToken() else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        return AF.request(apiUrl, method: .post, parameters: createAddressResponse, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .publishDecodable(type: CreateAddressResponse.self)
            .value()
            .mapError { error in
                error
            }
            .eraseToAnyPublisher() // Return the publisher as AnyPublisher
    }
    
    func deleteAddress(addressId: Int) -> AnyPublisher<Void, Error> {
        let apiUrl = APIConstants.Address.delete
        
        let parameters: [String: Any] = [
            "addressId": addressId
        ]
        
        // Ensure there's a token available
        guard let headers = setupHeaderToken() else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        return AF.request(apiUrl, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<299) // Ensure the status code is valid
            .publishData()
            .tryMap { response in
                if let error = response.error {
                    throw error // Throw the error if there's one
                }
                return () // Return Void if the response is successful
            }
            .mapError { error in
                // Map error to a general `Error`
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func createContract(createContractRequest: ContractRequest) -> AnyPublisher<ContractResponse, Error> {
        let url = APIConstants.Contract.create
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .post, parameters: createContractRequest, encoder: JSONParameterEncoder.iso8601, headers: headers)
            .validate()
            .publishDecodable(type: ContractResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getContractById(contractId: Int) -> AnyPublisher<GetContractByIdResponse, Error> {
        let url = APIConstants.Contract.getById
        
        let headers = setupHeaderToken()
        
        let param: [String : Any] = [
            "contractId": contractId
        ]
        
        return AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: GetContractByIdResponse.self)
            .value()
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func createOrderRental(order: Order) -> AnyPublisher<OrderResponse, Error> {
        let url = APIConstants.Order.createOrderRental
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .post, parameters: order, encoder: JSONParameterEncoder.iso8601, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData() // Use `publishData` to inspect the response data
            .tryMap { response in
                if let statusCode = response.response?.statusCode, statusCode == 400 {
                    // Return a custom error message for status code 400
                    throw APIError.custom(message: "Đơn hàng của bạn đã tạo rồi")
                }
                return response.data ?? Data()
            }
            .decode(type: OrderResponse.self, decoder: JSONDecoder())
            .mapError { error in
                // Handle or map other errors here if needed
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func updatePaymentOrderRental(orderId: Int, contractId: Int, paymentId: Int) -> AnyPublisher<Void, Error> {
        let url = APIConstants.Order.updatePaymentOrderRental
        
        let parameters: [String: Any] = [
            "orderId": orderId,
            "contractId": contractId,
            "paymentId": paymentId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300) // Chỉ thành công với status code 200-299
            .publishData() // Dùng publishData để kiểm tra dữ liệu trả về
            .tryMap { response in
                // Kiểm tra xem response có dữ liệu không, nếu không thì trả về lỗi
                guard response.data != nil else {
                    throw APIError.unexpectedError // Lỗi nếu không có dữ liệu
                }
                return () // Thành công thì trả về Void
            }
            .mapError { error in
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getHireOrderHistory(pageIndex: Int, pageSize: Int, status: Int) -> AnyPublisher<HireHistoryResponse, Error> {
        let url = APIConstants.Order.getHireOrderHistory
        
        let parameters: [String: Any] = [
            "pageIndex": pageIndex,
            "pageSize": pageSize,
            "status": status
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: HireHistoryResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                debugPrint(error)
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getBuyOrderHistory(pageIndex: Int, pageSize: Int, status: Int) -> AnyPublisher<BuyHistoryResponse, Error> {
        let url = APIConstants.Order.getBuyOrderHistory
        
        let parameters: [String: Any] = [
            "pageIndex": pageIndex,
            "pageSize": pageSize,
            "status": status
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: BuyHistoryResponse.self)
            .value()
            .mapError { error in
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func cancelOrder(id: Int) -> AnyPublisher<Void, Error> {
        let url = APIConstants.Order.cancelOrder + String(id)
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData() // Dùng publishData để kiểm tra dữ liệu trả về
            .tryMap { response in
                // Kiểm tra xem response có dữ liệu không, nếu không thì trả về lỗi
                guard response.data != nil else {
                    throw APIError.unexpectedError // Lỗi nếu không có dữ liệu
                }
                return () // Thành công thì trả về Void
            }
            .mapError { error in
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
        
    }
    
    func getTransactionHistory(pageIndex: Int, pageSize: Int, walletId: Int) -> AnyPublisher<[TransactionAPI], Error>{
        let url = APIConstants.Transaction.getHistory
        
        let parameters: [String: Any] = [
            "page": pageIndex,
            "size": pageSize,
            "walletId": walletId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: [TransactionAPI].self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListRegisteredAuction(pageIndex: Int, pageSize: Int) -> AnyPublisher<RegisteredRoomsResponse, Error> {
        let url = APIConstants.Room.getListRegisterdAuctionRoom
        
        let parameters: [String : Any] = [
            "page": pageIndex,
            "size": pageSize
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: RegisteredRoomsResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getRegistedAuctonById(roomId: Int) -> AnyPublisher<RegistedRoomResponse, Error> {
        let url = APIConstants.Room.getRegistedAuctionRoomById
        
        let param: [String: Any] = [
            "roomId": roomId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: RegistedRoomResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - OWNER
    func createPlant(plantData: [String: String], mainImage: UIImage?, additionalImages: [UIImage]) -> AnyPublisher<PlantResponse, APIError> {
        let url = APIConstants.Plant.createPlant
        let headers = setupHeaderToken()
        
        // Tạo multipart form data cho yêu cầu upload hình ảnh
        let multipartFormData = MultipartFormData()
        
        // Thêm các tham số vào multipart form data
        for (key, value) in plantData {
            multipartFormData.append(value.data(using: .utf8)!, withName: key)
        }
        
        // Kiểm tra và thêm main image vào request
        if let mainImage = mainImage, let imageData = mainImage.jpegData(compressionQuality: 0.5) {
            print("Main Image Data: \(imageData.count) bytes")
            multipartFormData.append(imageData, withName: "mainImageFile", fileName: "mainImage.jpg", mimeType: "image/jpeg")
        } else {
            print("Invalid main image format.")
            // Xử lý lỗi nếu định dạng ảnh không hợp lệ
        }
        
        // Kiểm tra và thêm các ảnh phụ vào request
        for (index, image) in additionalImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .post, headers: headers)
            .validate(statusCode: 200..<300) // Ensure this includes all success codes
            .publishData()
            .tryMap { response in
                // Log thông tin phản hồi để xem chi tiết
                if let statusCode = response.response?.statusCode {
                    print("Response Status Code: \(statusCode)") // Log statusCode
                }
                
                if let responseData = response.data {
                    print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "No Data")") // Log body response
                }
                
                if response.data == nil {
                    print("No data returned, raw response: \(String(describing: response.data))")
                    throw APIError.noData
                }
                return response.data ?? Data()
            }
            .decode(type: PlantResponse.self, decoder: JSONDecoder())
            .mapError { error in
                // Xử lý lỗi chi tiết
                print("Error occurred: \(error)") // Log lỗi để xem chi tiết
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.networkError // Nếu không phải lỗi APIError, coi là lỗi mạng
                }
            }
            .eraseToAnyPublisher()

    }
    
    // MARK: - Helper function to check image MIME type
    func getMimeType(from imageData: Data) -> String? {
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        guard let uti = CGImageSourceGetType(imageSource) else { return nil }
        
        // Chuyển đổi CFString thành String để so sánh
        let utiString = uti as String
        
        if utiString == UTType.jpeg.identifier {
            return "image/jpeg"
        } else if utiString == UTType.png.identifier {
            return "image/png"
        } else if utiString == UTType.gif.identifier {
            return "image/gif"
        } else {
            return nil
        }
    }
    
    func updateUserInformation(userInput: User, avatar: UIImage?) -> AnyPublisher<UserResponse, APIError> {
            let url = "https://sep490ne-001-site1.atempurl.com/api/v1/GetUser/Users/Update/Information/Id"
            let headers = setupHeaderToken()
            
            // Tạo multipart form data
            let multipartFormData = MultipartFormData()
            
            // Thêm các tham số vào form data
            multipartFormData.append(userInput.gender.data(using: .utf8)!, withName: "gender")
            multipartFormData.append(userInput.phoneNumber.data(using: .utf8)!, withName: "phoneNumber")
            multipartFormData.append(userInput.dateOfBirth.iso8601String.data(using: .utf8)!, withName: "dateOfBirth")
            multipartFormData.append(userInput.fullName.data(using: .utf8)!, withName: "fullName")
            multipartFormData.append(userInput.email.data(using: .utf8)!, withName: "email")
            multipartFormData.append(userInput.identificationCard.data(using: .utf8)!, withName: "identificationCard")
            
            // Kiểm tra nếu có avatar, thêm ảnh vào request
            if let avatarImage = avatar, let avatarData = avatarImage.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(avatarData, withName: "imageFile", fileName: "avatar.jpg", mimeType: "image/jpeg")
            }
            
            // Gửi request PUT
            return AF.upload(multipartFormData: multipartFormData, to: url, method: .put, headers: headers)
                .validate(statusCode: 200..<300)
                .publishData()
                .tryMap { response in
                    if let statusCode = response.response?.statusCode {
                        print("Response Status Code: \(statusCode)")
                    }
                    
                    if let responseData = response.data {
                        print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "No Data")")
                    }
                    
                    if response.data == nil {
                        throw APIError.noData
                    }
                    return response.data ?? Data()
                }
                .decode(type: UserResponse.self, decoder: JSONDecoder.customDateDecoder)
                .mapError { error in
                    print("Error occurred: \(error)")
                    if let apiError = error as? APIError {
                        return apiError
                    } else {
                        return APIError.networkError
                    }
                }
                .eraseToAnyPublisher()
        }

    
    func setupHeaderToken() -> HTTPHeaders? {
        guard let token = UserSession.shared.token else {
            return nil
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        return headers
    }
}
