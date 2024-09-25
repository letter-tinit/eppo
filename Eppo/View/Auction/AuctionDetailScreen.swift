//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionDetailScreen: View {
    // MARK: - PROPERTY
    @State var timeRemaining = 3600
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: true)
            
            HStack(spacing: 20) {
                ZStack(alignment: .center) {
                    LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Số dư ví")
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black)
                        
                        Text(1000000000, format: .currency(code: "VND"))
                            .fontWeight(.medium)
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
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
                HStack {
                    Text("Sen Đá Kim Cương Haworthia Cooperi")
                        .font(.title)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                        .padding(.horizontal)
                    
                    ZStack {
                        Color.lightBlue
                        
                        Text("P254")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 80, height: 60)
                }
                
                PictureSlider()
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
                        
                        Text(500000, format: .currency(code: "VND"))
                            .foregroundStyle(.red)
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .padding(.horizontal)
                    
                    AuctionDetailItem(title: "Thời gian mở đăng ký", content: "10/07/2024 08:00:00")
                    AuctionDetailItem(title: "Thời gian kết thúc đăng ký", content: "29/07/2024 17:00:00")
                    AuctionDetailItem(title: "Phí đăng ký tham gia đấu giá", content: "3.000.000 VNĐ")
                    AuctionDetailItem(title: "Bước giá", content: "50.000.000 VNĐ")
                    AuctionDetailItem(title: "Số bước giá tối đa/ lần trả", content: "Bước giá không giới hạn")
                    AuctionDetailItem(title: "Tiền đặt trước", content: "19.496.720.000 VNĐ")
                    AuctionDetailItem(title: "Phương thức đấu giá", content: "Trả giá lên và liên tục")
                    AuctionDetailItem(title: "Thời gian bắt đầu trả giá", content: "01/08/2024 10:10:00")
                    AuctionDetailItem(title: "Thời gian kết thúc trả giá", content: "01/08/2024 11:10:00")
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
                    
                    
                    Text("Cây sen đá vài năm trở lại đây như một phần không thể thiếu trong cuộc sống hàng ngày của mỗi người chúng ta. Mọi người sử dụng cây sen đá phần nhiều để trang trí làm đẹp cho không gian của riêng mình, với một số khác còn được sử dụng với mong muốn mang đến những may mắn và tài lộc trong phong thủy.")
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
            HStack(alignment: .top, spacing: 0) {
                Button {
                    
                } label: {
                    Image(systemName: "creditcard")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .overlay(alignment: .center) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .background(.white)
                                .clipShape(Circle())
                                .padding(.bottom, 20)
                                .padding(.leading, 30)
                        }
                        .foregroundStyle(.green)
                        .frame(width: UIScreen.main.bounds.size.width / 2, height: 80, alignment: .top)
                        .padding(.top, 16)
                }
                
                Divider()
                
                Button {
                    
                } label: {
                    
                    Text("Đăng Ký")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(.blue)
                        .frame(width: UIScreen.main.bounds.size.width / 2, height: 80, alignment: .top)
                        .padding(.top, 16)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 80, alignment: .top)
            .shadow(radius: 1, x: 1, y: 1)
        }
        .ignoresSafeArea(.all, edges: .vertical)
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionDetailScreen()
}
