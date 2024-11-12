//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomAvatarHeader: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 30
    
    var name: String
    var image: Image
    var withClose: Bool
    var isReturnMain: Bool = false

    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            HStack {
                CircleImageView(image: image, size: 40)
                
                Text(name)
                    .font(.system(size: 22, weight: .medium))
                
            }
            .padding(.leading, 30)
            
            Spacer()
            
            if isReturnMain {
                NavigationLink {
                    MainTabView()
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
        CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: true)
        
        Spacer()
    }
    .ignoresSafeArea(.all)
}
