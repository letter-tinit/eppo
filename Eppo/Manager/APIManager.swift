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
        static let createOwner = baseURL + "api/v1/Owner/CreateAccount/Owner"
        static let createCustomer = baseURL + "api/v1/Customer/CreateAccount/Customer"
    }
    
    struct Plant {
        static let getByType = baseURL + "api/v1/GetList/Plants/Filter/ByTypeEcommerceId"
        static let getByTypeAndCate = baseURL + "api/v1/GetList/Plants/Filter/TypeEcommerceIdAndCategoryId"
        static let getById = baseURL + "api/v1/Plant/"
        static let createPlant = baseURL + "api/v1/Plants/CreatePlant/ByToken"
        static let ownerPlant = baseURL + "api/v1/GetList/Plants/PlantOwner/ByTypeEcommerceId"
        static let accept = baseURL + "api/v1/GetList/Plants/Accept"
        static let waitToAccept = baseURL + "api/v1/GetList/Plants/WaitToAccept"
        static let unAccept = baseURL + "api/v1/GetList/Plants/UnAccept"
        static let feedBacks = baseURL + "api/v1/GetList/Feedback/ByPlant"
        static let search = baseURL + "api/v1/GetList/Plants/Search/Keyword"
        static let deleteById = baseURL + "api/v1/GetList/Plants/CancelContractPlant"
    }
    
    struct Room {
        static let getList = baseURL + "api/v1/GetList/Rooms"
        static let getByDate = baseURL + "api/v1/GetList/Rooms/SearchRoomByDate"
        static let getById = baseURL + "api/v1/GetList/Rooms/Check/Id"
        static let auctionRegistration = baseURL + "api/v1/GetList/UserRoom/Create/UserRoom"
        static let getListRegisterdAuctionRoom = baseURL + "api/v1/GetList/UserRoom/Registered/ByToken"
        static let getRegistedAuctionRoomById = baseURL + "api/v1/GetList/UserRoom/RoomId"
        static let getHistoryBid = baseURL + "api/HistoryBid/GetHistoryBidsByRoomId"
        static let getHistoryAuction = baseURL + "api/v1/GetList/History/AllRoom"

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
        static let getShippingFee = baseURL + "api/v1/Count/FreeShip/PlantId"
        static let getDeposit = baseURL + "api/CountValues/CalculateDeposit"
        static let ownerOrders = baseURL + "api/v1/Order/GetOrdersByOwner"
        static let updateStatus = baseURL + "api/v1/Order/UpdateOrderStatus"
        static let confirmDeliverite = baseURL + "api/v1/Order/UpdateDeliverOrderSuccess/"
        static let failDeliverite = baseURL + "api/v1/Order/UpdateDeliverOrderFail/"
        static let preparedOrder = baseURL + "api/v1/Order/UpdatePreparedOrderSuccess/"
        static let successRefund = baseURL + "api/v1/Order/UpdateReturnOrderSuccess"
        static let failedRefund = baseURL + "api/v1/Order/UpdateReturnOrderFail"
        static let feedbacks = baseURL + "api/v1/GetList/Feedback/Order/Delivered/Plant"
        static let createFeedback = baseURL + "api/v1/GetList/Feedback/Create/Feedback"
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
        static let createOwner = baseURL + "api/v1/GetList/Contracts/Create/Contract/Ownership"
        static let updateContact = baseURL + "api/v1/GetList/Contracts/IsSigned/Contract/Id?contractId="
    }
    
    struct Transaction {
        static let getHistory = baseURL + "api/v1/Transaction/GetAllTransactionsInWallet"
        static let create = baseURL + "api/v1/Transaction/CreateTransaction"
        static let createZalopayTransaction = baseURL + "api/v1/Payment/ZaloPay/Recharge"
    }
    
    struct Conversation {
        static let getAll = baseURL + "api/Conversation/GetByUser"
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
                    case 401:
                        throw APIError.custom(message: "Tài khoản và mật khẩu không chính xác")
                    case 403:
                        throw APIError.custom(message: "Không có quyền truy cập")
                    case 404:
                        throw APIError.custom(message: "Tài khoản và mật khẩu không chính xác")
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
    
    func searchPlant(searchText: String, pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.search) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "typeEcommerceId", value: String(typeEcommerceId)),
            URLQueryItem(name: "keyword", value: searchText)
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
    
    func createCustomer(signUpUser: SignUpUser) -> AnyPublisher<SignUpResponse, Error> {
        let url = APIConstants.Auth.createCustomer
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .post, parameters: signUpUser, encoder: JSONParameterEncoder.iso8601, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData() // Use `publishData` to inspect the response data
            .tryMap { response in
                if let statusCode = response.response?.statusCode, statusCode == 409 {
                    // Return a custom error message for status code 400
                    throw APIError.custom(message: "Tên đăng nhập hoặc email đã tồn tại")
                }
                return response.data ?? Data()
            }
            .decode(type: SignUpResponse.self, decoder: JSONDecoder())
            .mapError { error in
                // Handle or map other errors here if needed
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func createOwner(signUpUser: SignUpUser) -> AnyPublisher<SignUpResponse, Error> {
        let url = APIConstants.Auth.createOwner
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .post, parameters: signUpUser, encoder: JSONParameterEncoder.iso8601, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData() // Use `publishData` to inspect the response data
            .tryMap { response in
                if let statusCode = response.response?.statusCode, statusCode == 409 {
                    // Return a custom error message for status code 400
                    throw APIError.custom(message: "Tên đăng nhập hoặc email đã tồn tại")
                }
                return response.data ?? Data()
            }
            .decode(type: SignUpResponse.self, decoder: JSONDecoder())
            .mapError { error in
                // Handle or map other errors here if needed
                return error as Error
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
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
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
    
    func getHistoryBid(pageIndex: Int, pageSize: Int, roomId: Int) -> AnyPublisher<AuctionDetailHistoryResponse, Error> {
        let url = APIConstants.Room.getHistoryBid
        
        let headers = setupHeaderToken()
        
        let parameters: [String: Any] = [
            "pageIndex": pageIndex,
            "pageSize": pageSize,
            "roomId": roomId
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: AuctionDetailHistoryResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getHistoryAuction(pageIndex: Int, pageSize: Int) -> AnyPublisher<HistoryRoomResponse, Error> {
        let url = APIConstants.Room.getHistoryAuction
        
        let headers = setupHeaderToken()
        
        let parameters: [String: Any] = [
            "page": pageIndex,
            "size": pageSize
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: HistoryRoomResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
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
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
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
            .validate(statusCode: 200..<300) // You can also specify a valid range explicitly
            .responseDecodable(of: NotificationResponse.self, decoder: JSONDecoder.customDateDecoder) { response in
                switch response.result {
                case .success(let data):
                    print("Data: \(data)")
                    // Handle successful response, e.g., update UI or state
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    // Handle failure case
                }
            }
            .publishDecodable(type: NotificationResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func createOrder(createOrderRequest: CreateOrderRequest) -> AnyPublisher<SimpleResponse, Error> {
        let apiUrl = APIConstants.Order.createOrder
        
        // Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        
        return AF.request(apiUrl, method: .post, parameters: createOrderRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .publishDecodable(type: SimpleResponse.self)
            .value()
            .mapError { error in
                error // Handle and map error to the Combine error
            }
            .eraseToAnyPublisher() // Return the publisher as AnyPublisher
    }
    
    func getShippingFee(plantId: Int) -> AnyPublisher<ShippingFeeResponse, Error> {
        let url = APIConstants.Order.getShippingFee
        
        let parameters: [String: Any] = [
            "plantId": plantId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: ShippingFeeResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getDeposit(plantId: Int) -> AnyPublisher<ApiResponse<Double>, Error> {
        let url = APIConstants.Order.getDeposit
        
        let parameters: [String: Any] = [
            "plantId": plantId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: ApiResponse<Double>.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getMyInformation() -> AnyPublisher<UserResponse, Error> {
        let apiUrl = APIConstants.User.getMyInfor
        
        // Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        
        return AF.request(apiUrl, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: UserResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getMyInformationTest() -> AnyPublisher<UserResponseTest, Error> {
        let apiUrl = APIConstants.User.getMyInfor
        
        // Ensure there's a token available
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        
        return AF.request(apiUrl, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: UserResponseTest.self, decoder: JSONDecoder.customDateDecoder)
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
                    throw APIError.custom(message: "Đơn hàng của bạn đã tạo rồi, hãy kiểm tra lại lịch sử đặt hàng")
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
    
    func updatePaymentOrderRental(orderId: Int, contractId: Int, paymentId: Int) -> AnyPublisher<UpdatePaymentResponse, Error> {
        let url = APIConstants.Order.updatePaymentOrderRental
        
        var components = URLComponents(string: url)!
        components.queryItems = [
            URLQueryItem(name: "orderId", value: "\(orderId)"),
            URLQueryItem(name: "contractId", value: "\(contractId)"),
            URLQueryItem(name: "paymentId", value: "\(paymentId)")
        ]
        let finalURL = components.url!
        
        let headers = setupHeaderToken()
        
        return AF.request(finalURL, method: .put, headers: headers)
            .publishDecodable(type: UpdatePaymentResponse.self)
            .value()
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
    
    func getFeedBackOrder(pageIndex: Int, pageSize: Int) -> AnyPublisher<FeedBackResponse, Error> {
        let url = APIConstants.Order.feedbacks
        
        let parameters: [String: Any] = [
            "page": pageIndex,
            "size": pageSize
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: FeedBackResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                debugPrint(error)
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
    
    func createTransaction(walletId: Int, amount: Double) -> AnyPublisher<TransactionResponse, Error> {
        let url = APIConstants.Transaction.create
        
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        // Parameters
        let parameters: [String: Any] = [
            "walletId": walletId,
            "paymentId": 2,
            "withdrawNumber": 0.0,
            "rechargeNumber": amount
        ]
        
        return AF.upload(
            multipartFormData: { formData in
                for (key, value) in parameters {
                    if let value = value as? String {
                        formData.append(Data(value.utf8), withName: key)
                    } else if let value = value as? Int {
                        formData.append(Data("\(value)".utf8), withName: key)
                    } else if let value = value as? Double {
                        formData.append(Data("\(value)".utf8), withName: key)
                    }
                }
            },
            to: url,
            headers: headers
        )
        .validate()
        .publishDecodable(type: TransactionResponse.self, decoder: JSONDecoder())
        .value()
        .mapError { error in
            return error as Error
        }
        .eraseToAnyPublisher()
    }
    
    func createZalopayTransaction(amount: Double) -> AnyPublisher<TransactionResponse, Error> {
        let url = APIConstants.Transaction.createZalopayTransaction
        
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        // Parameters
        let parameters: [String: Any] = [
            "rechargeNumber": amount
        ]
        
        return AF.upload(
            multipartFormData: { formData in
                for (key, value) in parameters {
                    if let value = value as? String {
                        formData.append(Data(value.utf8), withName: key)
                    } else if let value = value as? Int {
                        formData.append(Data("\(value)".utf8), withName: key)
                    } else if let value = value as? Double {
                        formData.append(Data("\(value)".utf8), withName: key)
                    }
                }
            },
            to: url,
            headers: headers
        )
        .validate()
        .publishDecodable(type: TransactionResponse.self, decoder: JSONDecoder())
        .value()
        .mapError { error in
            return error as Error
        }
        .eraseToAnyPublisher()
    }
    
    func plantFeedBack(pageIndex: Int, pageSize: Int, plantId: Int) -> AnyPublisher<FeedBacksResponse, Error> {
        let url = APIConstants.Plant.feedBacks
        
        let parameters: [String: Any] = [
            "page": pageIndex,
            "size": pageSize,
            "plantId": plantId
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .publishData()
            .tryMap({ response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.unexpectedError
                }
                
                print(statusCode)
                
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                return responseData
            })
            .decode(type: FeedBacksResponse.self, decoder: JSONDecoder.customDateDecoder)
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - OWNER
    func createPlant(plantData: [String: String], mainImage: UIImage?, additionalImages: [UIImage]) -> AnyPublisher<PlantCreationResponse, APIError> {
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
            return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                .eraseToAnyPublisher()
        }
        
        // Kiểm tra và thêm các ảnh phụ vào request
        for (index, image) in additionalImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                    .eraseToAnyPublisher()
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .post, headers: headers)
            .validate(statusCode: 200..<300) // Ensure this includes all success codes
            .publishData()
            .tryMap { response in
                // Log thông tin phản hồi để xem chi tiết
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.unexpectedError
                }
                print("Response Status Code: \(statusCode)") // Log statusCode
                
                guard (200...299).contains(statusCode) else {
                    throw APIError.custom(message: "Tạo cây thất bại")
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
            .decode(type: PlantCreationResponse.self, decoder: JSONDecoder())
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
//        
//        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("multipart_form_data")
//        do {
//            try multipartFormData.writeEncodedData(to: tempFileURL)
//            print("MultipartFormData written to: \(tempFileURL)")
//            if let data = try? Data(contentsOf: tempFileURL),
//               let rawString = String(data: data, encoding: .utf8) {
//                print("Raw Multipart Form Data: \n\(rawString)")
//            }
//        } catch {
//            print("Failed to write MultipartFormData to file: \(error)")
//        }
        
        // Gửi request PUT
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                if statusCode >= 200 && statusCode <= 300 {
                    return responseData
                } else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       let errorMessage = jsonDict["error"] as? String {
                        print("Error Message: \(errorMessage)")
                        throw APIError.custom(message: errorMessage)
                    } else {
                        print("Unable to parse error message.")
                        throw APIError.custom(message: "Giải mã lỗi thất bại\nXin lỗi vì sự bất tiện này")
                    }
                }
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
    
    func getAllConversation() -> AnyPublisher<[Conversation], Error>{
        let url = APIConstants.Conversation.getAll
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: [Conversation].self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func createOwnerContract() -> AnyPublisher<OwnerContractResponse, Error> {
        let url = APIConstants.Contract.createOwner
        
        let headers = setupHeaderToken()
        
        let parameters: [String: Any] = [
            "contractUrl": "",
            "contractDetails": []
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                // Handle HTTP status codes
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200...299:
                        // If successful, return raw data
                        if let data = response.data {
                            return data
                        } else {
                            throw APIError.noData
                        }
                    case 400:
                        if let data = response.data {
                            return data
                        } else {
                            throw APIError.noData
                        }
                    case 401:
                        throw APIError.custom(message: "Unauthorized.")
                    case 403:
                        throw APIError.custom(message: "Forbidden.")
                    case 404:
                        throw APIError.custom(message: "Not found.")
                    case 500...599:
                        throw APIError.serverError(statusCode: statusCode)
                    default:
                        throw APIError.unexpectedError
                    }
                } else {
                    throw APIError.networkError
                }
            }
            .decode(type: OwnerContractResponse.self, decoder: JSONDecoder()) // Decode into OwnerContractResponse
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func updateContract(contractId: Int, status: Int) -> AnyPublisher<UpdateContractResponse, APIError>  {
        let url = APIConstants.Contract.updateContact + String(describing: contractId)
        
        let param: [String: Any] = [
            "status": status
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate()
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
            .decode(type: UpdateContractResponse.self, decoder: JSONDecoder()) // Giải mã dữ liệu
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
    
    func getOwnerOrders(pageIndex: Int, pageSize: Int) -> AnyPublisher<OwnerOrderResponse, Error> {
        let url = APIConstants.Order.ownerOrders
        
        let parameters: [String: Any] = [
            "pageIndex": pageIndex,
            "pageSize": pageSize
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: OwnerOrderResponse.self, decoder: JSONDecoder.customDateDecoder)
            .value()
            .mapError { error in
                debugPrint(error)
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func updateOrderStatus(orderId: Int, newStatus: Int) -> AnyPublisher<ApiResponse<Bool?>, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Order.updateStatus) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "orderId", value: String(orderId)),
            URLQueryItem(name: "newStatus", value: String(newStatus))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.badUrl
                }
                
                print(statusCode)
                
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                return responseData
            }
            .decode(type: ApiResponse<Bool?>.self, decoder: JSONDecoder())
            .mapError { error in
                debugPrint(error)
                // Xử lý lỗi hoặc trả về lỗi mặc định
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func confirmDeliverited(orderId: Int, images: [UIImage]) -> AnyPublisher<SimpleResponse, Error> {
        let url = APIConstants.Order.confirmDeliverite + String(describing: orderId)
        
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        // Tạo multipart form data
        let multipartFormData = MultipartFormData()
        
        
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                    .eraseToAnyPublisher()
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                if statusCode >= 200 && statusCode <= 300 {
                    return responseData
                } else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       let errorMessage = jsonDict["error"] as? String {
                        print("Error Message: \(errorMessage)")
                        throw APIError.custom(message: errorMessage)
                    } else {
                        print("Unable to parse error message.")
                        throw APIError.custom(message: "Giải mã lỗi thất bại\nXin lỗi vì sự bất tiện này")
                    }
                }
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder.customDateDecoder)
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
    
    func failDeliverited(orderId: Int, images: [UIImage]) -> AnyPublisher<SimpleResponse, Error> {
        let url = APIConstants.Order.failDeliverite + String(describing: orderId)
        
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        // Tạo multipart form data
        let multipartFormData = MultipartFormData()
        
        
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                    .eraseToAnyPublisher()
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                if statusCode >= 200 && statusCode <= 300 {
                    return responseData
                } else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       let errorMessage = jsonDict["error"] as? String {
                        print("Error Message: \(errorMessage)")
                        throw APIError.custom(message: errorMessage)
                    } else {
                        print("Unable to parse error message.")
                        throw APIError.custom(message: "Giải mã lỗi thất bại\nXin lỗi vì sự bất tiện này")
                    }
                }
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder.customDateDecoder)
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
    
    func preparedOrder(orderId: Int) -> AnyPublisher<SimpleResponse, Error> {
        let url = APIConstants.Order.preparedOrder + String(describing: orderId)
        
        let headers = setupHeaderToken()
        
        
        return AF.request(url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                return responseData
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder.customDateDecoder)
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
    
    func successRefund(orderId: Int, depositDescription: String, depositReturnOwner: Double, images: [UIImage]) -> AnyPublisher<SimpleResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Order.successRefund) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "orderId", value: String(orderId)),
            URLQueryItem(name: "depositDescription", value: depositDescription),
            URLQueryItem(name: "percent", value: String(depositReturnOwner))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers = setupMultipartHeaderToken()
        
        let multipartFormData = MultipartFormData()
        
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                    .eraseToAnyPublisher()
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                return responseData
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder())
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
    
    func failedRefund(orderId: Int) -> AnyPublisher<SimpleResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Order.failedRefund) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "orderId", value: String(orderId))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                return responseData
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder())
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
    
    func createFeedback(description: String, plantId: Int, rating: Int, images: [UIImage]) -> AnyPublisher<SimpleResponse, Error> {
        let url = APIConstants.Order.createFeedback
        
        guard let token = UserSession.shared.token else {
            return Fail(error: NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: No token available"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        // Tạo multipart form data
        let multipartFormData = MultipartFormData()
        
        multipartFormData.append(description.data(using: .utf8)!, withName: "description")
        multipartFormData.append("\(plantId)".data(using: .utf8)!, withName: "plantId")
        multipartFormData.append("\(rating)".data(using: .utf8)!, withName: "rating")
        
        
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5),
               let mimeType = getMimeType(from: imageData) {
                multipartFormData.append(imageData, withName: "imageFiles", fileName: "image\(index).jpg", mimeType: mimeType)
            } else {
                print("Invalid additional image format for index \(index).")
                return Fail(error: APIError.custom(message: "Dữ liệu ảnh bị bỏ trống hoặc không hợp lệ"))
                    .eraseToAnyPublisher()
                // Xử lý lỗi nếu định dạng ảnh không hợp lệ
            }
        }
        
        return AF.upload(multipartFormData: multipartFormData, to: url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.networkError
                }
                guard let responseData = response.data else {
                    throw APIError.noData
                }
                
                print("Response Status Code: \(statusCode)")
                
                if statusCode >= 200 && statusCode <= 300 {
                    return responseData
                } else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
                       let jsonDict = jsonObject as? [String: Any],
                       let errorMessage = jsonDict["error"] as? String {
                        print("Error Message: \(errorMessage)")
                        throw APIError.custom(message: errorMessage)
                    } else {
                        print("Unable to parse error message.")
                        throw APIError.custom(message: "Giải mã lỗi thất bại\nXin lỗi vì sự bất tiện này")
                    }
                }
            }
            .decode(type: SimpleResponse.self, decoder: JSONDecoder.customDateDecoder)
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
    
    func getOwnerPlant(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
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
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getAcceptPlant(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.accept) else {
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
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getWaitToAcceptPlant(pageIndex: Int, pageSize: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.waitToAccept) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getUnAcceptPlant(pageIndex: Int, pageSize: Int) -> AnyPublisher<CategoryPlantResponse, Error> {
        guard var urlComponents = URLComponents(string: APIConstants.Plant.unAccept) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        // Set query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
            URLQueryItem(name: "pageSize", value: String(pageSize))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: CategoryPlantResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func deletePlant(plantId: Int) -> AnyPublisher<Void, Error> {
        let url = APIConstants.Plant.deleteById
        
        let parameters: [String: Any] = [
            "plantId": plantId
        ]
        
        let headers = setupHeaderToken()
        
        return AF.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<299)
            .publishData()
            .tryMap({ response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.invalidResponse
                }
                
                // Check if the status code is in the valid range
                if !(200..<300).contains(statusCode) {
                    throw APIError.serverError(statusCode: statusCode)
                }
                
                return response.data
            })
            .map({ _ in
                return ()
            })
            .mapError { error in
                return error as Error
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
    
    func setupMultipartHeaderToken() -> HTTPHeaders? {
        guard let token = UserSession.shared.token else {
            return nil
        }
        
        // Set up headers with the authorization token
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*",
            "Content-Type": "multipart/form-data"
        ]
        
        return headers
    }
}
