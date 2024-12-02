//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct HireItemDetailScreen: View {
    // MARK: - PROPERTY
    let id: Int
    @State var viewModel = ItemDetailsViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // MARK: - PICTURE SLIDER
                    PictureSlider(imagePlants: viewModel.plant?.imagePlants ?? [])
                    
                    // MARK: - CONTENT HEADER
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Giá chỉ:")
                                .font(.system(size: 18, weight: .medium))
                            
                            if let price = viewModel.plant?.finalPrice {
                                HStack(spacing: 0) {
                                    Text(price, format: .currency(code: "VND"))
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(.red)
                                    
                                    Text("/tháng")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(.red)
                                }
                            } else {
                                Text("unknow")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Text(viewModel.plant?.name ?? "Đang tải")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.black)
                        
                        Text(viewModel.plant?.title ?? "Đang tải")
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
                    
                    Rectangle()
                        .frame(height: 10)
                        .foregroundStyle(Color(uiColor: UIColor.systemGray4))
                    
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
                .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                .navigationBarBackButtonHidden()
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .onAppear {
                viewModel.getPlantById(id: id)
                viewModel.getFeedbacks(plantId: id)
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
                        .foregroundStyle(.black)
                }
            }
            //            .overlay(alignment: .topTrailing) {
            //                Button {
            //                    addToCart()
            //                    viewModel.isAlertShowing = true
            //                } label: {
            //                    Image(systemName: "cart")
            //                        .resizable()
            //                        .fixedSize()
            //                        .font(.system(size: 30, weight: .medium))
            //                        .padding(.trailing, 30)
            //                        .padding(.top, 20)
            //                        .foregroundStyle(.red)
            //                }
            //            }
            
            Divider()
            
            HStack(alignment: .top, spacing: 0) {
                Image(systemName: "calendar")
                    .font(.title)
                    .frame(width: UIScreen.main.bounds.size.width / 6)
                    .padding(.top, 20)
                    .overlay {
                        DatePicker(selection: $viewModel.selectedDate,
                                   in: Date()...,
                                   displayedComponents: .date) {}
                            .labelsHidden()
                            .contentShape(Rectangle())
                            .opacity(0.011)
                    }
                
                Divider()
                
                VStack(spacing: 10) {
                    Stepper(
                        value: $viewModel.numberOfMonth,
                        in: viewModel.range,
                        step: viewModel.step
                    ) {
                        Text("\(viewModel.numberOfMonth)")
                    }
                    .background(.clear)
                    
                    Text("\(viewModel.numberOfMonth) Tháng")
                    
                }
                .padding(20)
                
                NavigationLink {
                    HireOrderScreen(viewModel: viewModel)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Thuê cây")
                        if let price = viewModel.plant?.finalPrice {
                            HStack(spacing: 0) {
                                Text(price, format: .currency(code: "VND"))
                                Text("/tháng")
                            }
                        } else {
                            Text("Đang tải")
                        }
                    }
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.size.width / 2)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .background(.red)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 100)
            .shadow(radius: 2, y: 2)
        }
        .labelsHidden()
        .ignoresSafeArea(.all, edges: .bottom)
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message))
        }
    }
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    func addToCart() {
        guard let plant = viewModel.plant else {
            return
        }
        
        if plantExists(withId: plant.id, in: UserSession.shared.hireCart) {
            viewModel.message = "Đơn hàng đã có trong giỏ hàng của bạn rồi"
        } else {
            UserSession.shared.hireCart.append(plant)
            viewModel.message = "Đã thêm đơn hàng vào giỏ"
        }
    }
    
    func plantExists(withId id: Int, in plants: [Plant]) -> Bool {
        return plants.contains { $0.id == id }
    }
}


// MARK: - PREVIEW
#Preview {
    HireItemDetailScreen(id: 1)
}
