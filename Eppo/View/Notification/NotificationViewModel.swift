//
//  NotificationViewModel.swift
//  Eppo
//
//  Created by Letter on 10/11/2024.
//

import Foundation
import Combine
import Observation

@Observable 
class NotificationViewModel {
    var notificationResponseDatas: [NotificationResponseData] = []
    var latestNotification: NotificationAPI?

    var cancellables: Set<AnyCancellable> = []
    var isLoading = false
    
    func getListNotification() {
        isLoading = true
        
        guard let token = UserSession.shared.token else {
            return
        }
        
        APIManager.shared.getListNotifications(token: token, pageIndex: 1, pageSize: 999)
            .sink { result in
                self.isLoading = false
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { notificationResponse in
                self.notificationResponseDatas = notificationResponse.data
                self.latestNotification = notificationResponse.data.first?.notifications.first
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
