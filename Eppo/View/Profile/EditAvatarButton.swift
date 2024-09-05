//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct EditAvatarButton: View {
    // MARK: - PROPERTY
    var action: () -> Void
    
    // MARK: - BODY
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .frame(width: 36, height: 30)
                        .foregroundStyle(.gray)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 36, height: 30)
                        .foregroundStyle(.white)
                }
                
                Image(systemName: "pencil")
                    .foregroundStyle(.black)
                    .scaleEffect(1.2)
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    EditAvatarButton {
        print("A")
    }
}
