//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct HomeHeader: View {
    // MARK: - PROPERTY
    @ObservedObject var viewModel: HomeViewModel
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 30) {
            CustomAvatarHeader(withClose: false)
            
            HomeSearchBar(searchPlaceHolder: viewModel.recomendOption == .forBuy ? "Tìm cây mua" : "Tìm cây thuê", searchText: $viewModel.searchText)
                .padding(.horizontal)
                .submitLabel(.search)
                .onSubmit {
                    viewModel.navigateToResults = true
                }
            
            HStack(spacing: 30) {
                NavigationLink {
                    ItemBuyScreen()
                } label: {
                    VStack {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.blue)
                        
                        Text("Mua cây")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                NavigationLink {
                    ItemHireScreen()
                } label: {
                    VStack {
                        Image(systemName: "doc.plaintext")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.purple)
                        
                        Text("Thuê cây")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                NavigationLink {
                    AuctionRoomScreen()
                } label: {
                    VStack {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.green)
                        
                        Text("Phòng đấu giá")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                NavigationLink {
                    SupportScreen()
                } label: {
                    VStack {
                        Image(systemName: "questionmark.app")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.yellow)
                        
                        Text("Hỗ trợ")
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
    HomeHeader(viewModel: HomeViewModel())
}
