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
        NavigationView {
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
                                ToAuctionItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", price: 500000, time: "1/08 - 10:20")
                            }
                        }
                    }
                    .padding(.bottom, 70)
                    .padding(.horizontal, 8)
                }
                
                Spacer()
            }
            //            .background(Color.init(uiColor: UIColor.systemGray5))
            .ignoresSafeArea(.all)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionScreen()
}
