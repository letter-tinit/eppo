//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartStateHeader: View {
    // MARK: - PROPERTY
    @Binding var selectedCart: CartState

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 0) {
            ForEach(CartState.allCases, id: \.self) { cartState in
                Button {
                    withAnimation(.smooth(duration: 0.5)) {
                        selectedCart = cartState
                    }
                    
                } label: {
                    VStack(spacing: 4) {
                        Text(cartState.rawValue)
                            .font(.headline)
                            .foregroundStyle(.black)
                        
                        Rectangle()
                            .frame(height: 2)
                            .padding(.horizontal, 60)
                            .foregroundStyle(selectedCart == cartState ? .orange : .clear)

                    }
                    .frame(width: UIScreen.main.bounds.size.width / 2)
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CartStateHeader(selectedCart: .constant(.buy))
}
