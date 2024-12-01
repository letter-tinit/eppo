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
                        LinearGradient(colors: [.white, Color(uiColor: .systemGray5), .white], startPoint: .bottomLeading, endPoint: .topTrailing)
                            .opacity(0.7)
                    )
                    .font(.headline)
            }
            .background(Color(uiColor: UIColor.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(width: 140, height: 120)
            .shadow(color: .gray.opacity(0.6), radius: 1, x: 1, y: 1)
        }
    }
}

import SwiftUI

struct CustomLoadingCenterView: View {
    // MARK: - PROPERTY
    var title: String
    
    init(title: String) {
        self.title = title
    }

    // MARK: - BODY
    
    var body: some View {
        CenterView {
            ZStack {
                ProgressView(title)
                    .padding(30)
                    .background(
                        LinearGradient(colors: [.white, Color(uiColor: .systemGray5), .white], startPoint: .bottomLeading, endPoint: .topTrailing)
                            .opacity(0.7)
                    )
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(width: 180, height: 160)
            .shadow(color: .gray.opacity(0.6), radius: 1, x: 1, y: 1)
        }
    }
}

// MARK: - PREVIEW
#Preview {
//    LoadingCenterView()
    CustomLoadingCenterView(title: "A")
}
