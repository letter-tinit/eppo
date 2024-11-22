//
//  SignUp.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import Foundation

struct SignUpUser: Codable {
    var userName: String
    var fullName: String
    var password: String
    var confirmPassword: String
    var gender: String
    var dateOfBirth: Date
    var phoneNumber: String
    var addressDescription: String
    var email: String
    var identificationCard: String
    var role: String
}

extension SignUpUser {
    func isAllFieldsInputted() -> Bool {
        // Check string properties are not empty and date is valid
        return !userName.isEmpty &&
        !fullName.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !gender.isEmpty &&
        !phoneNumber.isEmpty &&
        !addressDescription.isEmpty &&
        !email.isEmpty &&
        !identificationCard.isEmpty &&
        dateOfBirth != Date.distantPast
    }
    
    func isPasswordMatch() -> Bool {
        return password == confirmPassword
    }
}
