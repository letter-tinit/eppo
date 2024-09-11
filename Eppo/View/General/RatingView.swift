//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct RatingView: View {
    // MARK: - PROPERTY
    var rating: Double
    var font: Font
    
    var integerPart: Int {
        return Int(rating)
    }
    
    var fractionalPart: Double {
        return rating - Double(integerPart)
    }
    
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    var halfImage = Image(systemName: "star.leadinghalf.filled")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    // MARK: - BODY
    
    var body: some View {
        
        HStack(spacing: 2) {
            ForEach(1..<integerPart + 1, id: \.self) { number in
                onImage
                    .foregroundStyle(onColor)
            }
            
            if fractionalPart > 0 && fractionalPart < 10 {
                halfImage
                    .foregroundStyle(onColor)
                
                ForEach(1..<5 - integerPart, id: \.self) { number in
                    offImage
                        .foregroundStyle(offColor)
                }
                
            } else {
                ForEach(1..<6 - integerPart, id: \.self) { number in
                    offImage
                        .foregroundStyle(offColor)
                }
            }
            
        }
        .font(font)
    }
}

// MARK: - PREVIEW
#Preview {
    RatingView(rating: 4.0, font: .title3)
}
