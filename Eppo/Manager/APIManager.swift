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
        static let getById = baseURL + "https://sep490ne-001-site1.atempurl.com/api/v1/Plant"
    }
    
    struct Room {
        static let getListRoom = baseURL + "https://sep490ne-001-site1.atempurl.com/api/v1/GetList/Rooms"
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
    
//    func getPlantByType(pageIndex: Int, pageSize: Int, typeEcommerceId: Int) -> AnyPublisher<[Plant], Error> {
//        guard let url = URL(string: APIConstants.Plant.getByType) else {
//            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
//        }
//        
//        let parameters: [String: Any] = [
//            "pageIndex": pageIndex,
//            "pageSize": pageSize,
//            "typeEcommerceId": typeEcommerceId
//        ]
//        
//        return AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default)
//            .publishDecodable(type: [Plant].self)
//            .value()
//            .mapError { error in
//                return error as Error
//            }
//            .eraseToAnyPublisher()
//    }
    
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
        guard let url = URL(string: "https://sep490ne-001-site1.atempurl.com/api/v1/Plant/\(id)") else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }

        return AF.request(url, method: .get)
            .publishDecodable(type: Plant.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getListAuctionRoom(id: Int) -> AnyPublisher<AuctionResponse, Error> {
        guard let url = URL(string: "https://sep490ne-001-site1.atempurl.com/api/v1/Plant/1") else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }

        // Set query parameters
//        urlComponents.queryItems = [
//            URLQueryItem(name: "id", value: String(id)),
//        ]
//
//        guard let url = urlComponents.url else {
//            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
//        }

        return AF.request(url, method: .get)
            .publishDecodable(type: AuctionResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
}
