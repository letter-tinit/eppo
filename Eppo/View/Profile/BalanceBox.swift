//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct BalanceBox: View {
    // MARK: - PROPERTY
    var balance: Double
    
    @State var isShowing: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center, spacing: 30) {
                    Text("Số dư ví")
                        .font(.system(size: 20, weight: .medium))
                    
                    Spacer()
                    
                    Button {
                        isShowing.toggle()
                    } label: {
                        Image(systemName: isShowing ? "eye" : "eye.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                }
                
                if isShowing {
                    Text(balance, format: .currency(code: "VND"))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                    
                } else {
                    Text("● ● ●   ● ● ●   ● ● ●   ● ● ●")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 100, alignment: .topLeading)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom))
        )
    }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    BalanceBox(balance: 100000000000)
}
