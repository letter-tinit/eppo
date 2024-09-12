//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct SearchBar: View {
    // MARK: - PROPERTY
    @Binding var searchText: String

    // MARK: - BODY
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title3)
            
            TextField("Nhập từ khoá", text: $searchText)
                .font(.system(size: 18))
                .textInputAutocapitalization(.never)
            
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .frame(height: 45)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.textFieldBackground)
        )
    }
}

// MARK: - PREVIEW
#Preview {
    SearchBar(searchText: .constant("Cay canh"))
}
