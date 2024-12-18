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
        .foregroundStyle(.black)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.textFieldBackground)
        )
    }
}

struct HomeSearchBar: View {
    // MARK: - PROPERTY
    var searchPlaceHolder: String
    @Binding var searchText: String
    
    init(searchPlaceHolder: String, searchText: Binding<String>) {
        self.searchPlaceHolder = searchPlaceHolder
        self._searchText = searchText
    }

    // MARK: - BODY
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.title3)
            
            TextField(searchPlaceHolder, text: $searchText)
                .font(.system(size: 18))
                .textInputAutocapitalization(.never)
            
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .frame(height: 45)
        .foregroundStyle(.black)
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
