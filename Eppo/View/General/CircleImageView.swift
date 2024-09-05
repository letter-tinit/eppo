//
// Created by Treasure Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CircleImageView: View {
    // MARK: - PROPERTY
    var image: Image
    var size: CGFloat
    
    // MARK: - BODY
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(
                Circle()
            )
            .clipped()
            .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
    }
}

// MARK: PREVIEW
#Preview {
    CircleImageView(image: Image("avatar"), size: 40)
}
