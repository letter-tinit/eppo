//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionRoomDetailScreen: View {
    // MARK: - PROPERTY
    @State var viewModel: AuctionRoomDetailViewModel = AuctionRoomDetailViewModel()
    let userRoomId: Int
    let customers = Array(0..<3)
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: true)
            
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
                        viewModel.getRegistedAuctionRoomById(userRoomId: self.userRoomId)
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
                    
                    ZStack(alignment: .center) {
                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Text("Số người đăng ký")
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
                    .frame(width: 160, height: 70)
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
                        if var timeRemaining = viewModel.starTimeRemaining {
                            Text("\(minuteString(time: timeRemaining)) : \(secondString(time: timeRemaining))")
                                .onReceive(timer) { _ in
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
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
                
                ScrollView(.vertical, showsIndicators: false) {
                    PictureSlider()
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
                            ForEach(customers.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Nguyễn Văn An")
                                            .font(.system(size: 20, weight: .medium))
                                        Spacer()
                                        
                                        Text("5.700.000")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(index == 0 ? .red : .gray)
                                    }
                                    
                                    Text("10:37:50")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.gray)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                
                                if index != customers.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        .padding(.vertical)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.darkBlue.opacity(0.08)))
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            } else {
                CenterView {
                    Text("Không có dữ liệu")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .vertical)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getRegistedAuctionRoomById(userRoomId: self.userRoomId)
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
    AuctionRoomDetailScreen(userRoomId: 1)
}
