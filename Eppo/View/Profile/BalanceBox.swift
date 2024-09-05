//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct BalanceBox: View {
    // MARK: - PROPERTY
    var balance: String
    
    @State var isShowing: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .center, spacing: 30) {
                    Text("Số dư ví")
                        .font(.system(size: 20, weight: .medium))
                    
                    Button {
                        isShowing.toggle()
                    } label: {
                        Image(systemName: isShowing ? "eye" : "eye.slash")
                            .foregroundStyle(.black)
                    }
                }
                
                if isShowing {
                    HStack {
                        Text(balance)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                        
                        Text("VND")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    
                } else {
                    Text("●●●  ●●●  ●●●")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .frame(width: 200, height: 100, alignment: .topLeading)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom))
        )
    }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
    BalanceBox(balance: "10.000.000")
}
