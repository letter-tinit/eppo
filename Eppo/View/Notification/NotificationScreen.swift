//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationScreen: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            SingleHeaderView(title: "Thông báo")
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Thông báo mới nhất")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    NotificationRow(notificationTitle: "Tiêu đề thông báo", notificationTime: "10:00 AM", notificationContent: "Nội dung của thông báo", isFocusedNotification: true)
                }
                ForEach(0 ..< 2) { index in
                    Section {
                        ForEach(0 ..< 6) { _ in
                            NotificationRow(notificationTitle: "Tiêu đề thông báo", notificationTime: "10:00 AM", notificationContent: "Nội dung của thông báo")
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
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - PREVIEW
#Preview {
    NotificationScreen()
}
