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
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    @State private var selectedType: String = "Cây để bàn"
        let categories = ["Cây văn phòng", "Cây để bàn", "Cây ban công", "Cây phong thủy", "Cây thủy sinh"]
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
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

                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedType = category }) {
                            Text(category)
                        }
                    }
                } label: {
                    ZStack {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                            Text(selectedType)
                        }
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                    }
                }
                .font(.title2)
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(data, id: \.self) { item in
                                NavigationLink {
                                    ItemDetailScreen()
                                } label: {
                                    ToBuyItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: "50.000₫", sold: 309)
                                }
                            }
                        }
                    }
                }// ITEM SCROLL VIEW
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden()
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW
#Preview {
    ItemBuyScreen()
}
