//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomHeaderView: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 30
    
    var title: String
    
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
                .font(.system(size: 22, weight: .semibold))
                .frame(alignment: .center)
                .padding(.leading, -buttonWidth)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 70, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: PREVIEW
#Preview(traits: .fixedLayout(width: UIScreen.main.bounds.size.width, height: 100)) {
    CustomHeaderView(title: "Giỏ hàng")
}