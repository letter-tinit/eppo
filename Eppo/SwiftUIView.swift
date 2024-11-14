//
//  SwiftUIView.swift
//  Eppo
//
//  Created by Letter on 14/11/2024.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var value = 0
    let step = 1
    let range = 1...99
    
    
    var body: some View {
        Stepper(
            value: $value,
            in: range,
            step: step
        ) {
            Text("\(step)")
        }
        .padding(10)
    }
}

#Preview {
    SwiftUIView()
}
