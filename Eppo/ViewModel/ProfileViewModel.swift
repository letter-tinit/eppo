//
//  ProfileViewModel.swift
//  Eppo
//
//  Created by Letter on 05/10/2024.
//

import Foundation

class ProfileViewModel {
    func logout() {
        UserSession.shared.clearSession()
    }
}
