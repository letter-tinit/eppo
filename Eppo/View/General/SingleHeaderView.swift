//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI


struct SingleHeaderView: View {
    // MARK: - PROPERTY
    var title: String
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
                .padding(.bottom, 6)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 80, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: PREVIEW
#Preview(traits: .fixedLayout(width: UIScreen.main.bounds.size.width, height: 100)) {
    SingleHeaderView(title: "Giỏ hàng")
}
