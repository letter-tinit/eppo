//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionRoomDetailScreen: View {
    // MARK: - PROPERTY
    @State var viewModel: AuctionRoomDetailViewModel
    @State var priceInputTextField: String = ""
    
    @State var isPriceInputPopup: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(viewModel: AuctionRoomDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AuctionDetailsHeader(isPriceInputPopup: $isPriceInputPopup)
            
            if viewModel.isLoading {
                VStack {
                    ProgressView("Đang tải dữ liệu...")
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.hasError {
                VStack(spacing: 16) {
                    Text(viewModel.errorMessage ?? "Lỗi không xác định")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                    Button("Thử lại") {
                        viewModel.getRegistedAuctionRoomById()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let registedRoomResponseData = viewModel.registedRoomResponseData {
                // Hiển thị nội dung khi có dữ liệu
                HStack(spacing: 20) {
                    ZStack(alignment: .center) {
                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Text("Số dư ví")
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.black)
                            
                            if let myInformation = UserSession.shared.myInformation,
                               let wallet = myInformation.wallet {
                                Text(wallet.numberBalance, format: .currency(code: "VND"))
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                            } else {
                                Text(0, format: .currency(code: "VND"))
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                            }
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 160, height: 70)
                    
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        VStack(alignment: .leading) {
                            Text("Số người")
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.black)
                            
                            Text(registedRoomResponseData.registeredCount, format: .number)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 120, height: 70)
                }
                .padding()
                
                HStack {
                    Text(registedRoomResponseData.room.room.plant.name)
                        .font(.title)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "clock")
                            .font(.title)
                        if viewModel.starTimeRemaining == 0 {
                            Text("\(minuteString(time: viewModel.endTimeRemaining)) : \(secondString(time: viewModel.endTimeRemaining))")
                                .onReceive(timer) { _ in
                                    if viewModel.endTimeRemaining > 0 {
                                        viewModel.endTimeRemaining -= 1
                                    } else {
                                        self.timer.upstream.connect().cancel()
                                    }
                                }
                        } else {
                            Text("Chưa bắt đầu")
                        }
                    }
                    .foregroundStyle(.red)
                    .shadow(radius: 2)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.lightBlue)
                    )
                    
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    PictureSlider(imagePlants: registedRoomResponseData.room.room.plant.imagePlants)
                        .shadow(radius: 4)
                        .padding(.top)
                    
                    VStack(spacing: 30) {
                        HStack {
                            Text("Diễn biến cuộc đấu giá")
                                .font(.system(size: 20, weight: .medium))
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Thể lệ")
                                    Image(systemName: "questionmark.circle.fill")
                                }
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.gray)
                            }
                        }
                        
                        LazyVStack {
                            ForEach(viewModel.bidhistories) { historyBid in
                                LazyVStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Người chơi \(historyBid.userId)")
                                            .font(.system(size: 20, weight: .medium))
                                        Spacer()
                                        
                                        Text(historyBid.bidAmount, format: .currency(code: "VND"))
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                    
                                    Text(historyBid.bidTime, format: .dateTime)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.gray)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                
//                                if index != customers.count - 1 {
//                                    Divider()
//                                }
                            }
                        }
                        .padding(.vertical)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.darkBlue.opacity(0.08)))
                    }
                    .padding()
                }
            } else {
                CenterView {
                    Text("Không có dữ liệu")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getRegistedAuctionRoomById()
            viewModel.getHistoryBids()
            viewModel.connectWebSocket()
        }
        .sheet(isPresented: $isPriceInputPopup, content: {
            VStack(alignment: .trailing, spacing: 20) {
                BorderTextField {
                    TextField("Nhập giá tiền", text: $priceInputTextField)
                        .keyboardType(.numberPad)
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                Button {
                    self.isPriceInputPopup = false
                    viewModel.sendMessage(bidAmount: Int(priceInputTextField) ?? 0)
                } label: {
                    Text("Xác nhận")
                        .font(.headline)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(.blue)
                        )
                        .foregroundStyle(.white)
                        .padding(10)
                }
            }
            .shadow(radius: 2, x: 1, y: 1)
            .presentationDetents([.height(300)])
        })
        .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(title: Text(viewModel.currentErrorMessage ?? "Nhắc nhở"), dismissButton: .cancel())
        }
    }
    
    func minuteString(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        return String(format:"%02i", minutes)
    }
    
    func secondString(time: Int) -> String {
        let seconds = Int(time) % 60
        return String(format:"%02i", seconds)
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionRoomDetailScreen(viewModel: AuctionRoomDetailViewModel(roomId: 10))
}
