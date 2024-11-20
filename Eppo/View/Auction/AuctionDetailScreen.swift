//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionDetailScreen: View {
    // MARK: - PROPERTY
    var roomId: Int
    @State var viewModel = AuctionDetailsViewModel()
    @State var timeRemaining = 3600
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomAvatarHeader(name: UserSession.shared.myInformation?.fullName ?? "Đang tải", image: Image("avatar"), withClose: true)
            
            if let room = viewModel.room {
                HStack(spacing: 20) {
                    ZStack(alignment: .leading) {
                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading) {
                            Text("Số dư ví")
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(.black)
                            
                            Text(UserSession.shared.myInformation?.wallet?.numberBalance ?? 0, format: .currency(code: "VND"))
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
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
                            
                            Text(1000, format: .number)
                                .fontWeight(.medium)
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 160, height: 70)
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(alignment: .top) {
                        Text(room.plant.name)
                            .font(.title)
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                        
                        Spacer()
                        
                        Text("P.\(room.roomId)")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(
                                LinearGradient(colors: [.blue, .darkBlue, .lightBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
                            ))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    
                    PictureSlider(imagePlants: viewModel.room?.plant.imagePlants ?? [])
                        .shadow(radius: 4)
                        .padding(.top)
                    
                    VStack(spacing: 20) {
                        Text("Thời gian đếm ngược đấu giá")
                            .font(.system(size: 23, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(
                                LinearGradient(colors: [.red, .pink, .orange] , startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        
                        TimerView(timeRemaining: $timeRemaining)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Giá khởi điểm")
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text(room.plant.finalPrice, format: .currency(code: "VND"))
                                .foregroundStyle(.red)
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .padding(.horizontal)
                        
                        AuctionDetailItemWithDate(title: "Thời gian mở đăng ký", content: room.registrationOpenDate)
                        AuctionDetailItemWithDate(title: "Thời gian kết thúc đăng ký", content: room.registrationEndDate)
                        AuctionDetailItem(title: "Phí đăng ký tham gia đấu giá", content: String(describing: room.registrationFee.formatted(.currency(code: "VND"))))
                        AuctionDetailItem(title: "Bước giá", content: String(describing: room.priceStep.formatted(.currency(code: "VND"))))
                        AuctionDetailItem(title: "Số bước giá tối đa/lần trả", content: "Bước giá không giới hạn")
                        AuctionDetailItem(title: "Phương thức đấu giá", content: "Trả giá lên và liên tục")
                        AuctionDetailItemWithDate(title: "Thời gian bắt đầu trả giá", content: room.activeDate)
                        AuctionDetailItemWithDate(title: "Thời gian kết thúc trả giá", content: room.endDate)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: UIColor.systemGray6))
                    .padding(.vertical)
                    
                    VStack {
                        HStack {
                            Text("Mô Tả")
                                .font(.system(size: 24, weight: .medium))
                            Spacer()
                        }
                        
                        Text(room.plant.description)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color(uiColor: UIColor.darkBlue).opacity(0.1))
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                Spacer()
                
                Divider()
                
                // MARK: - FOOTER BUTTON
                Button {
                    viewModel.auctionRegistration()
                } label: {
                    Text("Đăng Ký")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.blue)
                        .frame(width: UIScreen.main.bounds.size.width / 2, height: 80, alignment: .top)
                        .padding(.top, 16)
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 80, alignment: .top)
                .shadow(radius: 1, x: 1, y: 1)
            } else if viewModel.isLoading {
                CenterView {
                    ProgressView("Đang tải")
                }
            } else if viewModel.hasError {
                CenterView {
                    VStack {
                        Text("Tải thất bại")
                        
                        Button {
                            viewModel.getRoomById(roomId: roomId)
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
            }
        }
        .ignoresSafeArea(.all, edges: .vertical)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getRoomById(roomId: self.roomId)
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message ?? "Nhắc nhở"), dismissButton: .cancel())
        }
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionDetailScreen(roomId: 1)
}
