//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel = NotificationViewModel()
    // MARK: - BODY
    
    var body: some View {
        VStack {
            SingleHeaderView(title: "Thông báo")
            
            if viewModel.notificationResponseDatas.isEmpty {
                Spacer()
                
                Text("Bạn không có thông báo mới nào")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        Text("Thông báo mới nhất")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        
                        if let latestNotification = viewModel.latestNotification {
                            NotificationRow(notificationAPI: latestNotification, isFocusedNotification: true)
                        }
                        
                    }
                    
                    ForEach(viewModel.notificationResponseDatas, id: \.self) { notificationResponseData in
                        Section {
                            ForEach(notificationResponseData.notifications, id: \.self) { notification in
                                NotificationRow(notificationAPI: notification)
                            }
                        } header: {
                            TimelineBox(timeline: notificationResponseData.date)
                                .padding(.vertical, 20)
                        }
                    }
                }
                .padding(.bottom, 50)
                .background(.white)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear(perform: {
            viewModel.getListNotification()
        })
    }
}

// MARK: - PREVIEW
#Preview {
    NotificationScreen()
}
