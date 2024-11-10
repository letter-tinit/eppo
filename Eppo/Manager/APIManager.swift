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
        static let getList = baseURL + "api/v1/GetList/Categories?page=1&size=10"
    }
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error>  {
        let apiUrl = APIConstants.Auth.login
        
        let parameters = LoginRequest(userName: username, password: password)
        
        return Future<LoginResponse, Error> { promise in
            // Use Alamofire to make the request
            AF.request(apiUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
                .validate()
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let loginResponse):
                        promise(.success(loginResponse))
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                // Parse error response if data is available
                                let apiError = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                                promise(.failure(apiError))
                            } catch {
                                promise(.failure(error))
                            }
                        } else {
                            // Handle other network or validation errors
                            promise(.failure(error))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - FIX Get do not contains request body
    func getPlantByType(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<[Plant], Error> {
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
            .publishDecodable(type: [Plant].self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getPlantById(id: Int) -> AnyPublisher<Plant, Error> {
        guard let url = URL(string: APIConstants.Plant.getById + String(describing: id)) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        return AF.request(url, method: .get)
            .validate()
            .response { response in
                print(response.result as Any)
            }
            .publishDecodable(type: Plant.self)
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
        let url = "https://sep490ne-001-site1.atempurl.com/api/v1/GetList/Categories"
        let parameters: [String: Any] = [
            "page": 1,
            "size": 10
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
    
    func getPlantByTypeAndCate(pageIndex: Int, pageSize: Int, typeEcommerceId: Int, categoryId: Int) -> AnyPublisher<[Plant], Error> {
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
            .publishDecodable(type: [Plant].self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
}
