//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ItemBuyScreen: View {
    // MARK: - PROPERTY
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .leading)
                }
                
                SearchBar(searchText: $searchText)
                
                Button {
                } label: {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .leading)
                }
                
                Button {
                } label: {
                    Image(systemName: "message")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .leading)
                }
            }// HEADER HSTACK
            .padding(.horizontal)
            .foregroundStyle(.black)
            
            Spacer()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ItemBuyScreen()
}
