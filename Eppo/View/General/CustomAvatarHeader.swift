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
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            HStack {
//                CircleImageView(image: Image(systemName: "photo"), size: 40)
                CustomCircleAsyncImage(imageUrl: UserSession.shared.myInformation?.imageUrl ?? "https://static.vecteezy.com/system/resources/thumbnails/036/594/092/small_2x/man-empty-avatar-photo-placeholder-for-social-networks-resumes-forums-and-dating-sites-male-and-female-no-photo-images-for-unfilled-user-profile-free-vector.jpg", size: 40)
                
                Text(UserSession.shared.myInformation?.fullName ?? "tên")
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
}

// MARK: - PREVIEW
#Preview {
    VStack {
        CustomAvatarHeader(withClose: true)
        
        Spacer()
    }
    .ignoresSafeArea(.all)
}
