//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionRoomScreen: View {
    // MARK: - PROPERTY
    @State var viewModel: AuctionRoomViewModel = AuctionRoomViewModel()
    @State var searchText: String = ""
    @State private var date = Date()
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 30) {
            CustomHeaderView(title: "Các phòng đấu giá")
            
            //            HStack(spacing: 15) {
            //                SearchBar(searchText: $searchText)
            //
            //                Image(systemName: "calendar")
            //                    .resizable()
            //                    .scaledToFit()
            //                    .frame(width: 30, height: 30)
            //                    .foregroundStyle(.black)
            //                    .overlay {
            //                        DatePicker(selection: $date, displayedComponents: .date) {}
            //                            .labelsHidden()
            //                            .contentShape(Rectangle())
            //                            .opacity(0.011)
            //                    }
            //
            //                Button {
            //
            //                } label: {
            //                    Image(systemName: "slider.horizontal.3")
            //                        .resizable()
            //                        .scaledToFit()
            //                        .frame(width: 30, height: 30)
            //                        .foregroundStyle(.black)
            //                }
            //            }
            //            .padding(.horizontal)
            
            if viewModel.isLoading {
                LoadingCenterView()
            } else if viewModel.userRooms.isEmpty {
                CenterView {
                    Text("Bạn chưa đăng ký phòng đấu giá nào cả")
                        .foregroundStyle(.gray)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        ForEach(viewModel.userRooms) { userRoom in
                            NavigationLink {
                                AuctionRoomDetailScreen(viewModel: AuctionRoomDetailViewModel(roomId: userRoom.roomId))
                            } label: {
                                AuctionRoomItem(imageURL: userRoom.room.plant.mainImage, itemName: userRoom.room.plant.name, roomNumber: "P\(userRoom.roomId)", time: userRoom.room.activeDate)
                            }
                        }
                        .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                    }
                    .padding(.bottom, 70)
                    .padding(.horizontal, 8)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
        .foregroundStyle(.black)
        .onAppear {
            viewModel.getListRegistedAuctionRoom()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionRoomScreen()
}
