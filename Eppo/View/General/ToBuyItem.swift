//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ToBuyItem: View {
    // MARK: - PROPERTY
    var imageUrl: String
    var itemName: String
    var price: Double
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CustomAsyncImage(imageUrl: imageUrl, width: 160, height: 150)
            
            VStack(alignment: .leading, spacing: 4){
                Text(itemName)
                    .lineLimit(nil)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                
                Text(price, format: .currency(code: "VND"))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.red)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .frame(width: 160, height: 210, alignment: .top)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.5), radius: 2)
    }
}

// MARK: - PREVIEW
#Preview {
    ToBuyItem(imageUrl: "https://hws.https://hws.dev/paul2.jpgdev/paul2.jpg", itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: 50000)
}
