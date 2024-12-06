//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerItemDetailScreen: View {
    // MARK: - PROPERTY
    @State var plant: Plant
    @State private var viewModel = OwnerItemDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // MARK: - PICTURE SLIDER
                    PictureSlider(imagePlants: plant.imagePlants)
                    
                    // MARK: - CONTENT HEADER
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Giá chỉ:")
                                .font(.system(size: 18, weight: .medium))
                            
                            HStack(spacing: 0) {
                                Text(plant.finalPrice, format: .currency(code: "VND"))
                                Text("/tháng")
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.red)
                        }
                        
                        Text(plant.name)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(plant.title)
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
                        
                        Text(plant.description)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // MARK: - RATING
                    
                    if !viewModel.feedBacks.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Đánh giá sản phẩm")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.black)
                            
                            HStack {
                                RatingView(rating: viewModel.averageRating, font: .title2)
                                
                                Text("\(viewModel.averageRating.formatted(.number.precision(.fractionLength(1))))/5")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.red)
                                
                                Text("(\(viewModel.numberOfFeedbacks.formatted(.number.notation(.compactName))) đánh giá)")
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
                            ForEach(viewModel.feedBacks) { feedBack in
                                RateItem(feedback: feedBack)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("Cây này chưa có đánh giá nào")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                    }
                    
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
                        .foregroundStyle(.textDarkBlue)
                        .shadow(color: .black, radius: 10)
                }
            }
            
            
//            Divider()
//            
//            HStack(alignment: .top, spacing: 0) {
//                Button {
//                    
//                } label: {
//                    VStack {
//                        Text("Hủy Cho Thuê")
//                            .font(.headline)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.red)
//                            .frame(width: UIScreen.main.bounds.size.width / 2)
//                            .padding(.top, 12)
//                        
//                        Spacer()
//                    }
//                    .padding(.bottom, 20)
//                }
//                
//                Divider()
//                
//                Button {
//                    
//                } label: {
//                    VStack {
//                        Text("Xem Hợp Đồng")
//                            .font(.headline)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.black)
//                            .frame(width: UIScreen.main.bounds.size.width / 2)
//                            .padding(.top, 12)
//                        
//                        Spacer()
//                    }
//                    .padding(.bottom, 20)
//                }
//            }
//            .frame(width: UIScreen.main.bounds.size.width, height: 60)
//            .shadow(radius: 1, y: 1)
        }
        .labelsHidden()
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            viewModel.getFeedbacks(plantId: plant.id)
        }
    }
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}


struct SimpleOwnerItemDetailScreen: View {
    // MARK: - PROPERTY
    @State var plant: Plant
    
    @Environment(\.dismiss) private var dismiss
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // MARK: - PICTURE SLIDER
                    PictureSlider(imagePlants: plant.imagePlants)
                        .shadow(radius: 4)
                    
                    // MARK: - CONTENT HEADER
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Giá chỉ:")
                                .font(.system(size: 18, weight: .medium))
                            
                            HStack(spacing: 0) {
                                if plant.typeEcommerceId == 2 {
                                    Text("\(plant.finalPrice.formatted(.currency(code: "VND")))/tháng")
                                } else {
                                    Text(plant.finalPrice, format: .currency(code: "VND"))
                                }
                            }
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.red)
                            
                        }
                        
                        Text(plant.name)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(plant.title)
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
                        
                        Text(plant.description)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
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
                        .foregroundStyle(.textDarkBlue)
                        .shadow(color: .black, radius: 10)
                }
            }
        }
        .labelsHidden()
        .ignoresSafeArea(.container, edges: .bottom)
    }
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}

// MARK: - PREVIEW
#Preview {
    OwnerItemDetailScreen(plant: Plant(id: 1, name: "Name", title: "Title", finalPrice: 1000, description: "", mainImage: "", imagePlants: [ImagePlantResponse(id: 1, imageUrl: "")], status: 1, typeEcommerceId: 1))
}
