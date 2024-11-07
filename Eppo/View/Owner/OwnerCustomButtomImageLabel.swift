//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerCustomButtomImageLabel: View {
    // MARK: - PROPERTY
    let imageName: String
    let title: String

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            Text(title)
                .font(.system(size: 14))
        }
        .foregroundStyle(.black)
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerCustomButtomImageLabel(imageName: "list.clipboard.fill", title: "Chờ xác nhận")
}
