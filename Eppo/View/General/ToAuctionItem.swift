//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ToAuctionItem: View {
    // MARK: - PROPERTY
    var image: Image
    var itemName: String
    var price: Double
    var time: String

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image("sample-bonsai-01")
                .resizable()
                .frame(width: 164, height: 100, alignment: .top)
                .scaledToFit()
                .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(spacing: 4) {
                    Text("Thời gian: ")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text(time)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.red)
                }
                
                Text(itemName)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                
                
                HStack {
                    VStack(alignment: .trailing) {
                        Text("Giá khởi điểm")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                        
                        Text(price, format: .currency(code: "VND"))
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.red)
                    }
                    
                    ZStack(alignment: .center) {
                        Color.purple
                        Text("Chi tiết")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .frame(width: 46, height: 24, alignment: .trailing)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.5), radius: 2, y: 4)
    }
}

// MARK: - PREVIEW
#Preview {
    ToAuctionItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: 50000, time: "1/08 - 10:30")
}
