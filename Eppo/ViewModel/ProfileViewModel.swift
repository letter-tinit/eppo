//
//  ProfileViewModel.swift
//  Eppo
//
//  Created by Letter on 05/10/2024.
//

import Foundation
import Combine
import Observation

@Observable
class ProfileViewModel {
    
    var userResponse: UserResponse?
    
    var cancellables: Set<AnyCancellable> = []
    
    var message: String?
    
    // MARK: - MY ACCOUNT SCREEN BINDING
    var usernameTextField: String = ""
    var phoneNumberTextField: String = ""
    var emailTextField: String = ""
    //    var addressTextField: String = ""
    var idCodeTextField: String = ""
    var date = Date()
    var isFemale: Bool = false
    var isMale: Bool = true
    var isSelectedDate: Bool = false
    var isShowingAlert: Bool = false
    var isPopup: Bool = false

    // MARK: - MY ADDRESS SCREEN BINDING
    var addressTextField: String = ""
    
    
    func getMyInformation() {
        APIManager.shared.getMyInformation()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { userResponse in
                self.userResponse = userResponse
            }
            .store(in: &cancellables)
    }
    
    func setIsMale(_ isMale: Bool) {
        self.isMale = isMale
        self.isFemale = !isMale
    }
    
    func selectedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        return outputFormatter.string(from: self.date)
    }
    
    func dayOfBirth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let dateOfBirth = self.userResponse?.data.dateOfBirth else {
            return nil
        }
        
        let date = dateFormatter.date(from: dateOfBirth)
        
        return reformatDateStringToPassing(date ?? Date())
    }
    
    func reformatDateStringToPassing(_ date: Date) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        return outputFormatter.string(from: date)
    }
    
    func createAddress() {
        APIManager.shared.createAddress(createAddressResponse: CreateAddessRequest(description: self.addressTextField))
            .sink { completion in
                self.isShowingAlert = true
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.message = error.localizedDescription
                }
            } receiveValue: { createAddressResponse in
                print(createAddressResponse)
                self.message = createAddressResponse.message
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        UserSession.shared.clearSession()
    }
}
