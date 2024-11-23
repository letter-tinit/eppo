//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct FooterToolBar: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ChatViewModel
    @Binding var messageTextField: String
    
    // MARK: - BODY
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .overlay(alignment: .center) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .background(.white)
                            .clipShape(Circle())
                            .padding(.bottom, 20)
                            .padding(.leading, 30)
                    }
                    .foregroundStyle(.green)
            }
            
            TextField("Nhập tin nhắn", text: $messageTextField)
            .padding(10)
            .background(
                Capsule()
                    .foregroundStyle(Color(uiColor: UIColor.systemGray6))
            )
            
            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title)
            }
            .disabled(messageTextField.isEmpty)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .frame(width: UIScreen.main.bounds.size.width, height: 70, alignment: .top)
        .background(.white)
        .shadow(radius: 1, x: 1, y: 1)
    }
    
    private func sendMessage() {
        viewModel.sendMessage()
    }
}

// MARK: - PREVIEW
#Preview {
    FooterToolBar(viewModel: ChatViewModel(), messageTextField: .constant("Xin chào!"))
}
