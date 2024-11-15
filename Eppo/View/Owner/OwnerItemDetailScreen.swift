//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerItemDetailScreen: View {
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
                            
                            HStack(spacing: 0) {
                                Text(40000, format: .currency(code: "VND"))
                                Text("/tháng")
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.red)

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
                        
                        Text("Cam kết bảo hành")
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
                        
                        Text("Giao hàng nhanh tiện lợi")
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
                    VStack {
                        Text("Hủy Cho Thuê")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.size.width / 2)
                            .padding(.top, 8)
                        
                        Spacer()
                    }
                    .background(.purple)
                }
                
                Button {
                    
                } label: {
                    VStack {
                        Text("Xem Hợp Đồng")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.size.width / 2)
                            .padding(.top, 8)
                        
                        Spacer()
                    }
                    .background(.green)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 60)
            .shadow(radius: 2, y: 2)
        }
        .labelsHidden()
        .ignoresSafeArea(.all, edges: .bottom)
    }
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}


// MARK: - PREVIEW
#Preview {
    OwnerItemDetailScreen()
}
