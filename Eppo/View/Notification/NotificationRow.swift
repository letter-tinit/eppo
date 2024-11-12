//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationRow: View {
    // MARK: - PROPERTY
    var notification: Notification
    
    var isFocusedNotification: Bool = false

    // MARK: - BODY

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Notification Icon
            Image(systemName: "bell.and.waves.left.and.right")
                .font(.title)
                .foregroundStyle(.red)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                HStack {
                    // Notification Title
                    Text(notification.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Notification Time
                    Text("notificationTime")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                // Notification Content
                Text(notification.description)
                    .font(.subheadline)
            }
            .fontDesign(.rounded)
        }
        .padding()
        .background(isFocusedNotification ? .darkBlue.opacity(0.4) : Color(uiColor: UIColor.systemGray6))
        .overlay(alignment: .topTrailing, content: {
            Circle()
                .frame(width: 8, height: 8)
                .padding([.top, .trailing], 8)
                .foregroundStyle(.red)
        })
    }
}

// MARK: - PREVIEW
#Preview {
    NotificationRow(notification: Notification(
        notificationId: 1,
        title: "New Message",
        description: "You have received a new message.",
        isRead: false,
        isNotifications: true
    ))
}
