//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct PartnerChatBox: View {
    // MARK: - PROPERTY
    var avatar: Image
    var textMessage: String
    var textTime: Date
    
    @State var isShowingInformation: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        HStack(alignment: .top) {
            CircleImageView(image: avatar, size: 39)
                .padding(.leading, 12)
            
            VStack {
                if isShowingInformation {
                    Text(textTime, format: .dateTime)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
                
                Text(textMessage)
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                    )
                    .shadow(radius: 3, x: 2, y: 2)
            }
            
            Spacer(minLength: 60)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingInformation.toggle()
        }
        .animation(.easeInOut, value: isShowingInformation)
    }
}

// MARK: - PREVIEW
#Preview {
    PartnerChatBox(avatar: Image("avatar"), textMessage: "Xin chào! Mình muốn hỏi bạn một chút vấn đề về cây cảnh.", textTime: Date())
}
