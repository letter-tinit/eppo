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
    let type: String
    let title: String
    let status: Int
    let traceId: String
}

struct APIConstants {
    static let baseURL = "https://quangtrandeptrai-001-site1.atempurl.com/"
    
    struct Auth {
        static let login = baseURL + "api/v1/Users/Login"
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
                                // If parsing fails, return the original error
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
}
