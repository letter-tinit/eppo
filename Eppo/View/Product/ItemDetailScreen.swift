//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import Observation

struct ItemDetailScreen: View {
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
                        .foregroundStyle(.textDarkBlue)
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
//                        .overlay(alignment: .topTrailing) {
//                            Text(UserSession.shared.cart.count, format: .number.grouping(.never))
//                                .font(.caption)
//                                .foregroundStyle(.white)
//                                .fontWeight(.semibold)
//                                .padding(5)
//                                .background(Circle().foregroundStyle(.red))
//                                .padding(.trailing)
//                                .opacity(UserSession.shared.cart.isEmpty ? 0 : 1)
//                        }
//                }
//            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .onAppear {
                viewModel.getPlantById(id: id)
            }
            
            HStack(alignment: .top, spacing: 0) {
                Button {
                } label: {
                    Image(systemName: "message")
                        .font(.title)
                        .frame(width: UIScreen.main.bounds.size.width / 4)
                        .padding(.top, 10)
                }
                
                Divider()
                
                VStack {
                    Button {
                        viewModel.isAlertShowing = true
                        addToCart()
                    } label: {
                        Image(systemName: "cart")
                            .font(.title)
                            .frame(width: UIScreen.main.bounds.size.width / 4)
                            .padding(.top, 10)
                            .foregroundStyle(.black)
                            .overlay(alignment: .topTrailing) {
                                Text(UserSession.shared.cart.count, format: .number.grouping(.never))
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle().foregroundStyle(.red))
                                    .padding(.trailing)
                                    .opacity(UserSession.shared.cart.isEmpty ? 0 : 1)
                            }
                    }
                    .alert(isPresented: $viewModel.isAlertShowing) {
                        Alert(title: Text(viewModel.message))
                    }
                    
                    Button {
                        
                    } label: {
                        //                        EmptyView()
                    }
                }
                
                NavigationLink {
                    BuyOrderDetailsScreen(viewModel: viewModel)
                } label: {
                    VStack {
                        Text("Mua")
                        if let price = viewModel.plant?.finalPrice {
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
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message))
        }
    }
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    func addToCart() {
        guard let plant = viewModel.plant else {
            return
        }
        
        if plantExists(withId: plant.id, in: UserSession.shared.cart) {
            viewModel.message = "Đơn hàng đã có trong giỏ hàng của bạn rồi"
        } else {
            UserSession.shared.cart.append(plant)
            viewModel.message = "Đã thêm đơn hàng vào giỏ"
        }
    }
    
    func plantExists(withId id: Int, in plants: [Plant]) -> Bool {
        return plants.contains { $0.id == id }
    }
}

// MARK: - PREVIEW
#Preview {
    ItemDetailScreen(id: 1)
}
