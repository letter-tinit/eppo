//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionDetailItem: View {
    // MARK: - PROPERTY
    var title: String
    var content: String

    // MARK: - BODY

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text(content)
                .foregroundStyle(.red)
        }
        .font(.footnote)
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionDetailItem(title: "title", content: "content")
}
