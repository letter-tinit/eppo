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
        ZStack(alignment: .leading) {
            Color(.textFieldBackground)
            
            content()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    BorderTextField {
        TextField("placeholder", text: .constant("text field"))
    }
    .frame(height: 50)
    .padding(.horizontal)
}
