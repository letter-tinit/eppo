//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct RateItem: View {
    // MARK: - PROPERTY

    // MARK: - BODY

    var body: some View {
        HStack(alignment: .top) {
            CircleImageView(image: Image("avatar"), size: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Nguyễn Văn An")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.black)
                
                RatingView(rating: 4, font: .subheadline)
                
                Text("Cây rất thơm nha, chuẩn gen z, giao hành nhanh và cây phát triển tốt")
                    .font(.subheadline)
                
                HStack {
                    Image("sample-bonsai-01")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .clipped()
                    
                    Image("sample-bonsai-01")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .clipped()
                    
                    Image("sample-bonsai-01")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .clipped()
                    
                    Image("sample-bonsai-01")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .clipped()
                }
            }
            .padding(.top, 6)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RateItem()
}
