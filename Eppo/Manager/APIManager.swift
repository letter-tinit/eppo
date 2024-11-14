//
//  APIManager.swift
//  Eppo
//
//  Created by Letter on 04/10/2024.
//

import Foundation
import Alamofire
import Combine

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
    }
    
    struct Room {
        static let getList = baseURL + "api/v1/GetList/Rooms"
        static let getByDate = baseURL + "api/v1/GetList/Rooms/SearchRoomByDate"
        static let getById = baseURL + "api/v1/GetList/Rooms/Id"
    }
    
    struct Category {
        static let getList = baseURL + "api/v1/GetList/Categories"
    }
    
    struct Notification {
        static let getList = baseURL + "api/v1/GetList/Notification"
    }
    
    struct Order {
        static let createOrder = baseURL + "api/v1/Order"
    }
    
    struct User {
        static let getMyInfor = baseURL + "api/v1/GetUser/Users/Information/UserID"
    }
    
    
    struct Address {
        static let getList = baseURL + "api/v1/GetList/Address/OfByUserID/ByToken"
        static let create = baseURL + "api/v1/GetList/Address/CreateAddress"
        static let delete = baseURL + "api/v1/GetList/Address/Delete/AddressByToken/Id"
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
            .publishDecodable(type: AuctionResponse.self)
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
            URLQueryItem(name: "id", value: String(id))
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: AuctionDetailResponse.self)
            .value()
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
                if statusCode == 200 {
                    return (200, "Đơn hàng đã đặt thành công")
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
            .publishDecodable(type: UserResponse.self)
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
