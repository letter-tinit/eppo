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
            Image(systemName: "photo")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(4)
                .background(.gray.opacity(0.6))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding([.bottom, .trailing], 2)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    EditAvatarButton {
        print("A")
    }
}
