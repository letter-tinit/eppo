//
//  NotificationViewModel.swift
//  Eppo
//
//  Created by Letter on 10/11/2024.
//

import Foundation
import Combine
import Observation

@Observable class NotificationViewModel {
    var notifications: [Notification] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    func getListNotification() {
        guard let token = UserSession.shared.token else {
            return
        }
        
        APIManager.shared.getListNotifications(token: token, pageIndex: 1, pageSize: 10)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { notificationResponse in
                self.notifications = notificationResponse.data
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
