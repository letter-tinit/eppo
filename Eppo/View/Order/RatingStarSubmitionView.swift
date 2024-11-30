//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct RatingStarSubmitionView: View {
    // MARK: - PROPERTY
    @Binding var rating: Int
    
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    // MARK: - BODY
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            ForEach(1...5, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut) {
                        rating = index
                    }
                } label: {
                    if rating >= index {
                        onImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundStyle(onColor)
                            .scaleEffect(1.1) // Add scale effect when selected
                            .transition(.scale) // Smooth transition effect
                    } else {
                        offImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundStyle(offColor)
                    }
                }
                .animation(.spring(), value: rating) // Add spring animation
            }
        }
        .frame(width: .infinity)
    }
}

// MARK: - PREVIEW
#Preview {
    RatingStarSubmitionView(rating: .constant(3))
}
