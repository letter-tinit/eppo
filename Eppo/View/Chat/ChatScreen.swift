//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ChatScreen: View {
    // MARK: - PROPERTY
    @State var messageTextField: String = ""
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "EPPO - Hệ Thống Cây Cảnh")
            
            ScrollView(.vertical) {
                ForEach(0 ..< 5) { index in
                    Section {
                        LazyVStack(spacing: 20) {
                            PartnerChatBox(avatar: Image("avatar"), textMessage: "Xin chào, bạn có thắc mắc gì?", textTime: "11:00 AM")
                            
                            MyChatBox(textMessage: "Loại cây này trồng vào không khí ở Mỹ có thích hợp không?", textState: index == 4 ? "Sending" : "Sent" , textTime: "10:10 AM")
                        }
                    } header: {
                        TimelineBox(timelineText: "03:22 04/09/2024")
                            .padding(.vertical, 20)
                    }
                }
                .padding(.bottom)
            }
            .defaultScrollAnchor(.bottom)
            .padding(.bottom, 80)
            .overlay(alignment: .bottom) {
                FooterToolBar(messageTextField: $messageTextField)
            }
            
            // MARK: - FOOTER BUTTON
//            FooterToolBar(messageTextField: $messageTextField)
//                .modifier(KeyboardAdaptive())
        }
        .background(Color(uiColor: .systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW
#Preview {
    ChatScreen()
}
