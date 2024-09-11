//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct ToBuyItem: View {
    // MARK: - PROPERTY
    var image: Image
    var itemName: String
    var price: String
    var sold: Int

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image("sample-bonsai-01")
                .resizable()
                .frame(width: 160, height: 100, alignment: .top)
                .scaledToFit()
                .clipped()
            
            VStack(alignment: .leading, spacing: 4){
                Text("Sen Đá Kim Cương Haworthia Cooperi")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                
                
                Text("50.000₫")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.red)
                
                Text("Đã bán \(sold)")
                    .font(.system(size: 8, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray)
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
    ToBuyItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: "50.000₫", sold: 302)
}
