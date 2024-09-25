//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OrderHistoryScreen: View {
    // MARK: - PROPERTY

    // MARK: - BODY

    var body: some View {
        VStack {
            CustomHeaderView(title: "Title")
            
            Spacer()
            
        }
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

// MARK: - PREVIEW
#Preview {
    OrderHistoryScreen()
}
