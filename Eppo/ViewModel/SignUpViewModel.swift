//
//  SignUpViewModel.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation
import Observation
import Combine

@Observable
class SignUpViewModel {
    let fakeSignUpUser = SignUpUser(
        userName: "john_doe",
        fullName: "John Doe",
        password: "Password123!",
        confirmPassword: "Password123!",
        gender: "Nam",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date(),
        phoneNumber: "0987654321",
        addressDescription: "123 Nguyễn Huệ, Quận 1, TP.HCM",
        email: "johndoe@example.com",
        identificationCard: "123456789",
        role: "Người bán"
    )
    
    var signUpUser: SignUpUser
    var message: String = ""
    var isAlertShowing: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.signUpUser = SignUpUser(userName: "", fullName: "", password: "", confirmPassword: "", gender: "Nam", dateOfBirth: Date(), phoneNumber: "", addressDescription: "", email: "", identificationCard: "", role: "Người bán")
    }
    
    func signUpAccount() {
        guard signUpUser.isPasswordMatch() else {
            isAlertShowing = true
            message = "Mật khẩu và xác thực không giống nhau"
            return
        }
        
        guard signUpUser.isAllFieldsInputted() else {
            isAlertShowing = true
            message = "Bạn chưa điền đủ tất cả thông tin"
            return
        }
        
        print(signUpUser)
    }
}
