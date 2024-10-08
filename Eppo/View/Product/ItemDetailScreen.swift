//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ItemDetailScreen: View {
    // MARK: - PROPERTY
    @State private var currentPage = 0
    let images = ["sample-bonsai", "sample-bonsai-01"]
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // MARK: - PICTURE SLIDER
                    PictureSlider()
                    
                    // MARK: - CONTENT HEADER
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Giá chỉ:")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("40.000đ/tháng")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.red)
                            
                            Text("70.000 đ/tháng")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.secondary)
                                .strikethrough()
                        }
                        
                        Text("Thạch Xương Bồ")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text("Thạch xương bồ là cây thân cỏ, sống dai, thân rễ mọc bò ngang, nhiều đốt và phân nhánh.")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }// CONTENT VSTACK
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                            .resizable()
                            .fixedSize()
                            .font(.title3)
                            .foregroundStyle(.green)
                        
                        Text("Đổi ý miễn phí 10 ngày")
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Image(systemName: "truck.box.fill")
                            .resizable()
                            .fixedSize()
                            .font(.title3)
                            .foregroundStyle(
                                LinearGradient(colors: [.red, .orange, .yellow], startPoint: .leading, endPoint: .trailing)
                            )
                        
                        Text("Nhận hàng từ 30/7 - 31/7, phí giao 0đ")
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // MARK: - DESCRIPTION
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mô tả")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text("Cây sen đá vài năm trở lại đây như một phần không thể thiếu trong cuộc sống hàng ngày của mỗi người chúng ta. Mọi người sử dụng cây sen đá phần nhiều để trang trí làm đẹp cho không gian của riêng mình, với một số khác còn được sử dụng với mong muốn mang đến những may mắn và tài lộc trong phong thủy")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .frame(height: 10)
                        .background(Color(uiColor: UIColor.systemGray4))
                    
                    // MARK: - RATING
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Đánh Giá sản phẩm")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.black)
                        
                        HStack {
                            RatingView(rating: 4.5, font: .title2)
                            
                            Text("4.5/5")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.red)
                            
                            Text("(2.1k đánh giá)")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(.secondary)
                            
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Đánh giá")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        RateItem()
                        RateItem()
                        RateItem()
                    }
                    .padding(.horizontal)
                    
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden()
            }
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .fixedSize()
                        .font(.system(size: 30, weight: .medium))
                        .padding(.leading, 30)
                        .padding(.top, 20)
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 10)
                }
            }
            
            
            Divider()
            
            HStack(alignment: .top, spacing: 0) {
                Button {
                    
                } label: {
                    Image(systemName: "message")
                        .font(.title)
                        .frame(width: UIScreen.main.bounds.size.width / 4)
                        .padding(.top, 10)
                }
                
                Divider()
                
                Button {
                    
                } label: {
                    Image(systemName: "cart")
                        .font(.title)
                        .frame(width: UIScreen.main.bounds.size.width / 4)
                        .padding(.top, 10)
                }
                
                Button {
                    
                } label: {
                    VStack {
                        Text("Mua hàng")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                        
                        Text("428.321 VND")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.size.width / 2)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(.red)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 80)
            .shadow(radius: 2, y: 2)
        }
        .labelsHidden()
        .ignoresSafeArea(.all, edges: .bottom)
    }
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}


// MARK: - PREVIEW
#Preview {
    ItemDetailScreen()
}
