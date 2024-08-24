//
//  BorderTextField.swift
//  eppo
//
//  Created by Letter on 22/08/2024.
//

import SwiftUI

struct BorderTextField<Content: View>: View {
    let content: () -> Content

    var body: some View {
        ZStack {
            Color(.textFieldBackground)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.6), lineWidth: 1)
            
            content()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    BorderTextField {
        TextField("placeholder", text: .constant("text field"))
    }
}
