//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartItemView: View {
    // MARK: - PROPERTIES
    @Binding var cartItem: Cart
    var onRemove: () -> Void
    var onToggleCheck: () -> Void
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Toggle Check Button
            Button {
                onToggleCheck()
            } label: {
                Image(systemName: cartItem.isCheckedOut ? "checkmark.square.fill" : "square")
                    .fontWeight(.semibold)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.green)
            }
            
            // Item Image
            Image("sample-bonsai")
                .resizable()
                .frame(width: 90, height: 90)
                .clipped()
                .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(cartItem.cartName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button {
                        onRemove()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                            .foregroundStyle(.red)
                    }
                }
                
                HStack {
                    Text("Đổi ý 15 ngày")
                        .font(.caption)
                        .padding(3)
                        .border(.mint)
                        .foregroundStyle(.mint)
                        .lineLimit(1)
                    
                    Stepper(value: $cartItem.quantity, in: 1...cartItem.remainingQuantity) {}
                }
                
                HStack {
                    Text(cartItem.currentPrice, format: .currency(code: "VND"))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                    
                    Text(cartItem.originalPrice, format: .currency(code: "VND"))
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .strikethrough()
                    
                    Spacer()
                    
                    Text("SL: \(cartItem.quantity)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .font(.subheadline)
                }
            }
        }
        .padding(10)
        .background(Color(uiColor: UIColor.systemGray6))
    }
}


// MARK: - PREVIEW
//#Preview {
//    CartItemView()
//}
