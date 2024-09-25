//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct TimelineBox: View {
    // MARK: - PROPERTY
    var timelineText: String

    // MARK: - BODY

    var body: some View {
        
        Text(timelineText)
            .font(.system(size: 12))
            .foregroundStyle(.white)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.gray)
                    .opacity(0.5)
            )
    }
}

// MARK: - PREVIEW
#Preview {
    TimelineBox(timelineText: "03:22 04/09/2024")
}
