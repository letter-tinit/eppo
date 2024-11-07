//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerBalanceBox: View {
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
                    
                    Spacer()
                    
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
            .frame(width: UIScreen.main.bounds.size.width - 20, height: 100, alignment: .topLeading)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom))
        )
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerBalanceBox(balance: "10.000.000")
}
