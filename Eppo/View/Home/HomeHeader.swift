//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct HomeHeader: View {
    // MARK: - PROPERTY
    @State private var searchText = ""
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 30) {
            CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: true)
            
            HStack(spacing: 15) {
                SearchBar(searchText: $searchText)
                
                Button {
                    
                } label: {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 30) {
                NavigationLink {
                    ItemBuyScreen()
                } label: {
                    VStack {
                        Image("bonsai")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                        Text("Cây cảnh")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }

                NavigationLink {
                    
                } label: {
                    VStack {
                        Image("tool")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                        Text("Phụ kiện")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                NavigationLink {
                    AuctionRoomScreen()
                } label: {
                    VStack {
                        Image("auction-room")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                        Text("Phòng đấu giá")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                Button {
                    
                } label: {
                    VStack {
                        Image("service")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                        
                        Text("Dịch vụ")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .background(Color.white)
    }
}

// MARK: - PREVIEW
#Preview {
    HomeHeader()
}
