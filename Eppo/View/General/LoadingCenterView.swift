//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct LoadingCenterView: View {
    // MARK: - PROPERTY

    // MARK: - BODY
    
    var body: some View {
        CenterView {
            ZStack {
                ProgressView("Đang tải")
                    .padding(30)
                    .background(
                        Color(uiColor: UIColor.systemGray5)
                            .opacity(0.4)
                    )
                    .font(.headline)
            }
            .background(Color(uiColor: UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(width: 140, height: 120)
            .shadow(radius: 3, x: 2, y: 2)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    LoadingCenterView()
}
