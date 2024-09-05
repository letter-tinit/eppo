//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct GenderRadioButton: View {
    // MARK: - PROPERTY
    var title: String
    
    @Binding var isSelected: Bool

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 30) {
            if isSelected {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1.5)
                        .frame(width: 22, height: 23)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill()
                        .frame(width: 14, height: 16)
                }
                .foregroundStyle(.gray)
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1.5)
                    .frame(width: 22, height: 23)
                    .foregroundStyle(.gray)
            }
            
            Text(title)
                .foregroundStyle(.gray)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    GenderRadioButton(title: "Male", isSelected: .constant(false))
}
