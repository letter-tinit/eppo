//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct DeliveredOrderRowView: View {
    // MARK: - PROPERTY
    var image: Image
    var itemName: String
    var itemType: String
    var originalPrice: Double
    var currentPrice: Double
    var quantity: Int
    var totalPrice: Double

    // MARK: - BODY

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                // Item Image
                Image("sample-bonsai")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
                
                VStack(alignment: .leading) {
                    Text(itemName)
                        .font(.headline)
                        .lineLimit(1)

                    Text(itemType)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(1)

                    HStack {
                        Text("Đổi ý 15 ngày")
                            .font(.caption)
                            .padding(3)
                            .border(.mint)
                            .foregroundStyle(.mint)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(originalPrice, format: .currency(code: "VND"))
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .strikethrough()
                        
                        Text(currentPrice, format: .currency(code: "VND"))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding(10)
            
            Divider()
            
            HStack {
                // Quantity
                Text("\(quantity) sản phẩm")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Thành tiền:")
                    .font(.subheadline)
                    .foregroundStyle(.black)

                
                // Total Price
                Text(totalPrice, format: .currency(code: "VND"))
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            HStack {
                Text("Đánh giá giúp dịch vụ được cải thiện tốt hơn")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                
                
                Spacer(minLength: 20)
                
                Button {
                    
                } label: {
                    Text("Đánh giá")
                        .frame(width: 120, height: 40)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.darkBlue)
                        )
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
        }
        .frame(height: 210)
        .background(.white)
    }
}

// MARK: - PREVIEW
#Preview {
    DeliveredOrderRowView(image: Image("sample-bonsai"), itemName: "Cây cảnh phong thuỷ đã tạo kiểu", itemType: "Đã tạo kiểu", originalPrice: 190000, currentPrice: 150000, quantity: 1, totalPrice: 200000)
}
