//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct HireItemDetailScreen: View {
    // MARK: - PROPERTY
    
    let id: Int
    @ObservedObject var viewModel = ItemDetailsViewModel()
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
                            
                            if let price = viewModel.plant?.price {
                                HStack(spacing: 0) {
                                    Text(price, format: .currency(code: "VND"))
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(.red)
                                    
                                    Text("Ngày")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(.red)
                                }
                            } else {
                                Text("unknow")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Text(viewModel.plant?.name ?? "Unknow")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(viewModel.plant?.description ?? "Unknow")
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
                        
                        Text(viewModel.plant?.description ?? "Unknow")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 10)
                        .foregroundStyle(Color(uiColor: UIColor.systemGray4))
                    
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
                .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                .navigationBarBackButtonHidden()
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .onAppear {
                DispatchQueue.main.async {
                    UIScrollView.appearance().bounces = true
                }
                viewModel.getPlantById(id: self.id)
            }
            .onDisappear {
                DispatchQueue.main.async {
                    UIScrollView.appearance().bounces = false
                }
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
    HireItemDetailScreen(id: 1)
}
