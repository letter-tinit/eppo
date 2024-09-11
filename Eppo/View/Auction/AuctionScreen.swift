//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionScreen: View {
    // MARK: - PROPERTY
    @State var searchText: String = ""
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: false)
                
                HStack(spacing: 15) {
                    SearchBar(searchText: $searchText)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "message")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        ForEach(data, id: \.self) { item in
                            NavigationLink {
                                AuctionDetailScreen()
                            } label: {
                                ToBuyItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: "50.000₫", sold: 302)
                            }
                            
                        }
                    }
                }
                
                Spacer()
            }
            .ignoresSafeArea(.all)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionScreen()
}
