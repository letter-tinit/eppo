//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomAvatarHeader: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 30
    
    var withClose: Bool
    var isReturnMain: Bool = false
    @Environment(\.dismiss) var dismiss
    @Bindable var userSession = UserSession.shared

    // MARK: - BODY
    
    var body: some View {
        HStack {
            HStack {
                CustomCircleAsyncImage(imageUrl: userSession.myInformation?.imageUrl ?? placeholderImage, size: 40)
                
                Text(userSession.myInformation?.fullName ?? "Tên")
                    .font(.system(size: 22, weight: .medium))
                
            }
            .padding(.leading, 30)
            
            Spacer()
            
            if isReturnMain {
                NavigationLink {
                    MainTabView(selectedTab: .explore)
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .scaledToFill()
                        .fontWeight(.medium)
                        .padding(.trailing, 30)
                        .frame(width: 30, height: 30)
                }
                .opacity(withClose ? 1 : 0)
            } else {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .scaledToFill()
                        .fontWeight(.medium)
                        .padding(.trailing, 30)
                        .frame(width: 30, height: 30)
                }
                .opacity(withClose ? 1 : 0)
            }
            
            
        }
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 90, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
    
    private var placeholderImage: String {
        "https://static.vecteezy.com/system/resources/thumbnails/036/594/092/small_2x/man-empty-avatar-photo-placeholder.jpg"
    }
}

// MARK: - PREVIEW
#Preview {
    VStack {
        CustomAvatarHeader(withClose: true)
        
        Spacer()
    }
    .ignoresSafeArea(.all)
}
