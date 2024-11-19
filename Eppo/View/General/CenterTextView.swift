//
//  CenterTextView.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import SwiftUI

struct CenterView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    CenterView {
        Text("Không có dữ liệu")
            .font(.headline)
            .foregroundColor(.gray)
    }
}

