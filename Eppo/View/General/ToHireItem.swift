//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ToHireItem: View {
    // MARK: - PROPERTY
    var imageUrl: String
    var itemName: String
    var price: Int
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: imageUrl), transaction: .init(animation: .bouncy(duration: 1))) { phase in
                switch phase {
                case .failure:
                    VStack(spacing: 20) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                        
                        Text("Tải ảnh thất bại")
                    }
                case .success(let image):
                    image
                        .resizable()
                default:
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .padding(.top, 8)
                        
                        Text("Đang tải ảnh...")
                        
                        ProgressView()
                    }
                }
            }
            .frame(width: 160, height: 150)
            .scaledToFill()
            .clipped()
            
            VStack(alignment: .leading, spacing: 4){
                Text(itemName)
                    .lineLimit(nil)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                
                HStack(spacing: 0) {
                    Text(price, format: .currency(code: "VND"))
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.red)
                    Text("/ngày")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.red)
                }
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
    ToHireItem(imageUrl: "https://hws.dev/paul2.jpg", itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: 50000)
}