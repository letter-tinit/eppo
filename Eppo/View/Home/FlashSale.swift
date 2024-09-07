//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct FlashSale: View {
    // MARK: - PROPERTY

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            Text("Flash Sale")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.red, .orange, .purple], startPoint: .top, endPoint: .bottom)
                )
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FlashSaleItem()
                    FlashSaleItem()
                    FlashSaleItem()
                    FlashSaleItem()
                    FlashSaleItem()
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(.vertical)
        .background(Color.white)
    }
}

// MARK: - PREVIEW
#Preview {
    FlashSale()
}
