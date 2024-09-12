//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct FlashSaleItem: View {
    // MARK: - PROPERTY

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 14) {
            Image("sample-bonsai")
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Text("Sen Đá Kim Cương Haworthia Cooperi")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .font(.system(size: 14, design: .rounded))
                .padding(.horizontal, 10)
            
            Text("50.000 VND")
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.red)
        }
        .frame(width: 140)
    }
}

// MARK: - PREVIEW
#Preview {
    FlashSaleItem()
}
