//
// Created by Treasure Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CircleImage: View {
    // MARK: - PROPERTY
  var image: Image

    // MARK: - BODY

  var body: some View {
    image
      .resizable()
      .scaledToFill()
      .frame(width: 40, height: 40)
      .clipShape(
        Circle()
      )
      .clipped()
      .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
  }
}

// MARK: PREVIEW
#Preview {
  CircleImage(image: Image("avatar"))
}
