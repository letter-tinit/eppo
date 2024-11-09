//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ItemDetailScreen: View {
    // MARK: - PROPERTY
    
    let id: Int
    @StateObject var viewModel = ItemDetailsViewModel()
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
                                Text(price, format: .currency(code: "VND"))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.red)
                                
                            } else {
                                Text("unknow")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Text(viewModel.plant?.name ?? "Đang tải")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(viewModel.plant?.description ?? "Đang tải")
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
                        
                        Text(viewModel.plant?.description ?? "Đang tải")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
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
                        Text("Mua")
                        if let price = viewModel.plant?.price {
                            Text(price, format: .currency(code: "VND"))
                        } else {
                            Text("Đang tải")
                        }
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
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
    ItemDetailScreen(id: 1)
}
