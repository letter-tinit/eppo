//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartItemView: View {
    // MARK: - PROPERTIES
    @Binding var cartItem: Cart
//    var on: () -> Void
    var onToggleCheck: () -> Void

    // MARK: - BODY
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
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
                    
                    Text("SL: \(cartItem.quantity)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.mint)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Đổi ý 15 ngày")
                        .font(.caption)
                        .padding(3)
                        .border(.mint)
                        .foregroundStyle(.mint)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Stepper(value: $cartItem.quantity, in: 1...cartItem.remainingQuantity) {}
                }
                
                HStack {
                    HStack(spacing: 0) {
                        Text(cartItem.currentPrice * Double(cartItem.quantity), format: .currency(code: "VND"))
                        if cartItem.isHireable {
                            Text("/ngày")
                        }
                    }
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
                    .font(.caption)

                    HStack {
                        Text(cartItem.originalPrice * Double(cartItem.quantity), format: .currency(code: "VND"))
                        if cartItem.isHireable {
                            Text("/ngày")
                        }
                    }
                    .lineLimit(1)
                    .font(.caption2)
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .strikethrough()
                }
            }
            Spacer()
        }
        .padding(10)
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
