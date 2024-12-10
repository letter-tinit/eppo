//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct PopoverRow: View {
    var title: String
    var contents: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(
                content: {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(contents, id: \.self) { content in
                            Text("• \(content)")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.gray.opacity(0.1))
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                },
                label: {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                }
            )
            .animation(.easeInOut(duration: 1), value: UUID())
            .tint(.black)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PopoverRow(title: "title", contents: ["content 1", "content 2"])
}
