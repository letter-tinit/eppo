//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct HistoryRoomScreen: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Lịch sử đấu giá")
            
            ZStack {
                
                if !viewModel.auctions.isEmpty {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.auctions, id: \.self) { auction in
                                HStack(alignment: .top) {
                                    CustomRoundedAsyncImage(imageUrl: auction.image, width: 100, height: 100)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(auction.roomName)
                                                .lineLimit(1)
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            Text(auction.userIsWinner ? "Thắng" : "Thua")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.white)
                                                .padding(.vertical, 2)
                                                .padding(.horizontal, 6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .foregroundStyle(auction.userIsWinner ? .green : .red)
                                                )
                                        }
                                        
                                        Text("Phí dăng ký: \(auction.registrationFee.formatted(.currency(code: "VND")))")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(.gray)
                                        
                                        Text(auction.winningBid, format: .currency(code: "VND"))
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .padding(10)
                                            .background(
                                                LinearGradient(colors: [.red, .orange, .yellow, .purple.opacity(0.7)], startPoint: .bottomLeading, endPoint: .topTrailing)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    auction.userIsWinner ? .green.opacity(0.1) : .red.opacity(0.1)
                                )
                            }
                        }
                    }
                } else if viewModel.hasError {
                    CenterView {
                        Text("Có lỗi xảy ra khi tải dữ liệu")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                } else if viewModel.isLoading {
                    EmptyView()
                } else {
                    CenterView {
                        Text("Không có dữ liệu trả về")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                }
                
                LoadingCenterView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getHistoryAuction()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HistoryRoomScreen(viewModel: ProfileViewModel())
}
