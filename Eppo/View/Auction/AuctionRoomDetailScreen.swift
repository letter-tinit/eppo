//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionRoomDetailScreen: View {
    // MARK: - PROPERTY
    @State var viewModel: AuctionRoomDetailViewModel
    @State var isPriceInputPopup: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var isPopoverShowing: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(viewModel: AuctionRoomDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AuctionDetailsHeader(isPriceInputPopup: $isPriceInputPopup)
            
            if viewModel.hasError {
                CenterView {
                    VStack {
                        Text("Tải thất bại")
                        
                        Button {
                            viewModel.getRegistedAuctionRoomById()
                        } label: {
                            Text("Thử lại")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(4)
                                .padding(.horizontal, 4)
                                .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(.darkBlue))
                        }
                    }
                }
            } else if let registedRoomResponseData = viewModel.registedRoomResponseData {
                switch viewModel.webSocketState {
                case .connecting:
                    HStack {
                        Text(viewModel.webSocketState.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Circle()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .foregroundStyle(.gray)
                case .connected:
                    HStack {
                        Text(viewModel.webSocketState.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Circle()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .foregroundStyle(.green)
                case .disconnected:
                    HStack {
                        Text(viewModel.webSocketState.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Circle()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .foregroundStyle(.red)
                }
                
                VStack {
                    // Hiển thị nội dung khi có dữ liệu
                    HStack(spacing: 10) {
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
                        .frame(width: 170, height: 70, alignment: .leading)
                        .padding(.horizontal)
                        .background(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                        
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
                        .frame(width: 80, height: 70)
                        .padding(.horizontal)
                        .background(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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
                                    isPopoverShowing.toggle()
                                } label: {
                                    HStack {
                                        Text("Thể lệ")
                                        Image(systemName: "questionmark.circle.fill")
                                    }
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.gray)
                                }
                                .popover(isPresented: $isPopoverShowing) {
                                    PopoverBSRule()
                                        .presentationCompactAdaptation(.popover)
                                }
                            }
                            
                            Text("Giá gợi ý tiếp theo: \(viewModel.recommendAuctionNext.formatted(.currency(code: "VND")))")
                                .multilineTextAlignment(.leading)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.darkBlue.opacity(0.08)))
                            
                            if !viewModel.bidhistories.isEmpty {
                                LazyVStack {
                                    ForEach(viewModel.bidhistories) { historyBid in
                                        LazyVStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                if viewModel.myInfor.userId == historyBid.userId {
                                                    Text("\(viewModel.myInfor.fullName) (bạn)")
                                                        .font(.system(size: 20, weight: .medium))
                                                } else {
                                                    Text("Người chơi \(historyBid.userId)")
                                                        .font(.system(size: 20, weight: .medium))
                                                }
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
                                        
                                        if historyBid.id != viewModel.bidhistories.last?.id {
                                            Divider()
                                        }
                                    }
                                }
                                .padding(.vertical)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.darkBlue.opacity(0.08)))
                                .redacted(reason: viewModel.isHistoryBidLoading ? .placeholder : .privacy)
                            } else {
                                Text("Vẫn chưa có người chơi nào ra giá")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                LoadingCenterView()
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getRegistedAuctionRoomById()
            viewModel.getHistoryBids()
        }
        .onChange(of: viewModel.starTimeRemaining, { _, newValue in
            if newValue <= 0 {
                viewModel.startAuction()
            }
        })
        .onChange(of: viewModel.endTimeRemaining, { _, newValue in
            if newValue <= 0 {
                viewModel.finishAuction()
            }
        })
        .onDisappear {
            viewModel.closeWebSocket()
        }
        .sheet(isPresented: $isPriceInputPopup, content: {
            VStack(alignment: .trailing, spacing: 20) {
                BorderTextField {
                    TextField("Nhập giá tiền", text: $viewModel.priceInput)
                        .keyboardType(.numberPad)
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(viewModel.recommendAmounts, id: \.self) { recommendAmount in
                            Button {
                                viewModel.setAmount(amount: recommendAmount)
                            } label: {
                                Text(Int(recommendAmount), format: .currency(code: "VND"))
                                    .font(.headline)
                                    .padding(6)
                                    .background(.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width - 40)
                .frame(height: 30)
                .padding()
                .scrollIndicators(.hidden)
                
                Button {
                    self.isPriceInputPopup = false
                    viewModel.sendMessage()
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
            Alert(title: Text(viewModel.currentErrorMessage ?? "Nhắc nhở"), dismissButton: .cancel({
                if viewModel.isAuctionFinish {
                    self.dismiss()
                }
            }))
        }
        .onChange(of: viewModel.priceInput) { _, _ in
            viewModel.setRecommendAmount()
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
    
    //    private func formattedPriceBinding() -> Binding<String> {
    //        Binding<String>(
    //            get: {
    //                if let priceInput = priceInputTextField {
    //                    // Use the currency formatter to display the formatted value
    //                    return NumberFormatter.currencyFormatter.string(from: NSNumber(value: priceInput)) ?? ""
    //                } else {
    //                    return "" // Return an empty string if no input
    //                }
    //            },
    //            set: { newValue in
    //                // Parse numeric value from the input
    //                let filtered = newValue.filter { $0.isNumber } // Extract numeric characters
    //                if let numericValue = Double(filtered) {
    //                    priceInputTextField = numericValue // Update the state with the numeric value
    //                } else {
    //                    priceInputTextField = nil // Reset if input cannot be parsed
    //                }
    //            }
    //        )
    //    }
}

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "VND"
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.maximumFractionDigits = 0 // No decimals for VND
        return formatter
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionRoomDetailScreen(viewModel: AuctionRoomDetailViewModel(roomId: 10))
}
