//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ToAuctionItem: View {
    // MARK: - PROPERTY
    var imageURL: String
    var itemName: String
    var price: Double
    var time: Date

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
//            Image("sample-bonsai-01")
//                .resizable()
//                .frame(width: 164, height: 100, alignment: .top)
//                .scaledToFit()
//                .clipped()
            CustomAsyncImage(imageUrl: imageURL, width: 164, height: 100)
            
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(spacing: 4) {
                    Text("Thời gian: ")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Text(time, format: .dateTime)
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
    ToAuctionItem(imageURL: "https://www.hackingwithswift.com/samples/paul2.jpg", itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: 50000, time: Date())
}
