//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import Combine

struct ChatScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = ChatViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 30) {
            CustomHeaderView(title: "Quản Trị Viên")
            ScrollView(.vertical) {
                ForEach(viewModel.messages) { message in
                        if message.userId == viewModel.myId {
                            MyChatBox(textMessage: message.message1, textState: "Sent" , textTime: message.creationDate)
                        } else {
                            PartnerChatBox(avatar: Image("avatar"), textMessage: message.message1, textTime: message.creationDate)
                        }
                        
                }
                if viewModel.isSending {
                    MyChatBox(textMessage: viewModel.messageTextField, textState: "Sending", textTime: Date.now)
                }
            }
            .defaultScrollAnchor(.bottom)
            .padding(.bottom, 80)
            .overlay(alignment: .bottom) {
                FooterToolBar(viewModel: viewModel, messageTextField: $viewModel.messageTextField)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getMessages()
            viewModel.connectWebSocket()
        }
    }
}
// MARK: - PREVIEW
#Preview {
    ChatScreen()
}
