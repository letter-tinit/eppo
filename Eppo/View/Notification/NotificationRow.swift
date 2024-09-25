//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationRow: View {
    // MARK: - PROPERTY
    var notificationTitle: String
    var notificationTime: String
    var notificationContent: String
    
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
                    Text(notificationTitle)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Notification Time
                    Text(notificationTime)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                // Notification Content
                Text(notificationContent)
                    .font(.subheadline)
            }
            .fontDesign(.rounded)
        }
        .padding()
        .background(isFocusedNotification ? .darkBlue.opacity(0.4) : Color(uiColor: UIColor.systemGray6))
    }
}

// MARK: - PREVIEW
#Preview {
    NotificationRow(notificationTitle: "Tiêu đề thông báo", notificationTime: "10:00 AM", notificationContent: "Nội dung của thồng báo")
}
