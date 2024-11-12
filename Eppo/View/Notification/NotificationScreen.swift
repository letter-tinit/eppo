//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationScreen: View {
    // MARK: - PROPERTY
    var viewModel = NotificationViewModel()
    // MARK: - BODY
    
    var body: some View {
        VStack {
            SingleHeaderView(title: "Thông báo")
            
            if viewModel.notifications.isEmpty {
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
                        
                        
                        NotificationRow(notification: viewModel.notifications[0], isFocusedNotification: true)
                    }
                    
                    ForEach(0 ..< 2) { index in
                        Section {
                            ForEach(0 ..< 6) { _ in
                                //                            NotificationRow(notificationTitle: "Tiêu đề thông báo", notificationTime: "10:00 AM", notificationContent: "Nội dung của thông báo")
                            }
                        } header: {
                            TimelineBox(timelineText: "26/06/2024")
                                .padding(.vertical, 20)
                        }
                    }
                }
                .padding(.bottom)
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
