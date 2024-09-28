//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomButtonImageLabel: View {
    // MARK: - PROPERTY
    let imageName: String
    let title: String

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 26)
            
            Text(title)
                .font(.system(size: 13))
        }
        .foregroundStyle(.black)
    }
}

// MARK: - PREVIEW
#Preview {
    CustomButtonImageLabel(imageName: "list.clipboard.fill", title: "Chờ xác nhận")
}
