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
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut) {
                        rating = index
                    }
                } label: {
                    if rating >= index {
                        onImage
                            .foregroundStyle(onColor)
                            .scaleEffect(1.2) // Add scale effect when selected
                            .transition(.scale) // Smooth transition effect
                    } else {
                        offImage
                            .foregroundStyle(offColor)
                    }
                }
                .animation(.spring(), value: rating) // Add spring animation
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RatingStarSubmitionView(rating: .constant(3))
}
