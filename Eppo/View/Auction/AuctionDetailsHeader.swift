//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionDetailsHeader: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 30
    
    var title: String = "Phòng đấu giá"
    @Binding var isPriceInputPopup: Bool

    @Environment(\.dismiss) var dismiss
    
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonWidth, alignment: .leading)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
                .padding(.bottom, 6)
                .padding(.leading, 12)
            
            Spacer()
            
            Button {
                self.isPriceInputPopup.toggle()
            } label: {
                Text("Ra Giá")
                    .font(.headline)
                    .frame(width: 52)
                    .foregroundStyle(.orange)
                    .shadow(color: .white, radius: 0.4)
            }
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 90, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionDetailsHeader(isPriceInputPopup: .constant(false))
}
