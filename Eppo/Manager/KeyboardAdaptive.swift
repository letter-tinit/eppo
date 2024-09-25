//
//  KeyboardAdaptive.swift
//  IOS15-TESTING
//
//  Created by Letter on 24/09/2024.
//

import SwiftUI

struct KeyboardAdaptive: ViewModifier {
    @ObservedObject private var keyboard = KeyboardResponder()

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.currentHeight)
//            .animation(.easeOut(duration: 0.16))
    }
}
