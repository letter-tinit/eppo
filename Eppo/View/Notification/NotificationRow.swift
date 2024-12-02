//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct NotificationRow: View {
    // MARK: - PROPERTY
    var notificationAPI: NotificationAPI
    
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
                    Text(notificationAPI.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    // Notification Time
                    Text(notificationAPI.createdDate.formatted(date: .omitted, time: .shortened))
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                // Notification Content
                Text(notificationAPI.description)
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
    NotificationRow(notificationAPI: NotificationAPI(title: "Tiêu đề", description: "Nội dung", createdDate: Date()))
}
