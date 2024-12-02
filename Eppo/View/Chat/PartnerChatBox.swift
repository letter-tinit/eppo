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
            
            VStack(alignment: .leading) {
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
                    .shadow(radius: 2, x: 1, y: 1)
            }
            .padding(.leading, 12)
            .padding(.vertical, 3)
            .animation(.easeInOut, value: isShowingInformation)

            Spacer(minLength: 60)
            
        }
        .padding(.horizontal, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isShowingInformation.toggle() // Thêm animation
            }
        }
        .animation(.easeInOut, value: isShowingInformation)
    }
}

// MARK: - PREVIEW
#Preview {
    PartnerChatBox(avatar: Image("avatar"), textMessage: "Xin chào! Mình muốn hỏi bạn một chút vấn đề về cây cảnh.", textTime: Date())
}
