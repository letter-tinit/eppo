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
    
    @Environment(\.dismiss) var dismiss
    
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            HStack {
                CircleImage(image: image)
                
                Text(name)
                    .font(.system(size: 22, weight: .medium))
                
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .resizable()
                .scaledToFill()
                .fontWeight(.medium)
                .padding(.trailing, 30)
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 80, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: - PREVIEW
#Preview {
    VStack {
        CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"))
        
        Spacer()
    }
    .ignoresSafeArea(.all)
}
