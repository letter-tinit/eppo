//
// Created by Treasure Letter ♥
//
// https://github.com/letter-tinit
//

import SwiftUI

struct HireOrderDetailHistoryScreen: View {
    // MARK: - PROPERTY
    let orderId: Int
    let plantId: Int
    @Bindable var viewModel: HireOrderViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CustomHeaderView(title: "Mã đơn: \(orderId)")
            
            ZStack {
                if let preReturnResponseData = viewModel.preReturnResponseData?.order,
                   let orderDetail = preReturnResponseData.orderDetails.first,
                   let contract = viewModel.preReturnResponseData?.contract,
                   let plant = viewModel.preReturnResponseData?.plant,
                   let plantUser = plant.plantUser
                {
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            PictureSlider(imagePlants: plant.imagePlants)
                            
                            Section {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(plant.name)
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    
                                    Text("\(plant.finalPrice.formatted(.currency(code: "VND")))/tháng")
                                        .font(.headline)
                                        .foregroundStyle(.red)
                                    
                                    Text(plant.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    
                                    NavigationLink {
                                        ShopPlantScreen(userName: plantUser.fullName, imageUrl: plantUser.imageUrl, code: plant.code)
                                    } label: {
                                        HStack(alignment: .bottom) {
                                            CustomCircleAsyncImage(imageUrl: plantUser.imageUrl, size: 30)
                                            
                                            Text(plantUser.fullName)
                                                .font(.headline)
                                                .foregroundStyle(.darkBlue)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                )
                            } header: {
                                Text("Thông tin cây")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.horizontal)
                            
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Ngày thuê")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        
                                        Spacer()
                                        
                                        Text(orderDetail.rentalStartDate, format: .dateTime.day().month().year())
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.green)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Ngày trả")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(orderDetail.rentalEndDate, format: .dateTime.day().month().year())
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.red)
                                        
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Số tháng")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(orderDetail.numberMonth, format: .number.grouping(.never))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Tiền thuê")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(plant.finalPrice, format: .currency(code: "VND"))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Tiền cọc")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(viewModel.deposit, format: .currency(code: "VND"))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Phí vận chuyển")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(preReturnResponseData.deliveryFee, format: .currency(code: "VND"))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Tổng tiền thuê")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(preReturnResponseData.finalPrice, format: .currency(code: "VND"))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.red)
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Hợp đồng thuê")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        NavigationLink {
                                            ViewContractScreen(url: contract.contractUrl)
                                        } label: {
                                            HStack {
                                                Text("Nhấn để xem")
                                                
                                                Image(systemName: "list.clipboard")
                                            }
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.blue)
                                        }
                                    }
                                    .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                )
                            } header: {
                                Text("Thông tin thuê")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.horizontal)
                            
                            Section {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Ngày ước tính trả")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        if let date = Date().addingDays(3) {
                                            Text(date, format: .dateTime.day().month().year())
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.purple)
                                        } else {
                                            Text("Không xác định")
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.purple)
                                        }
                                        
                                        
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Giá ước tính trả")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        Text(orderDetail.priceRentalReturnObject, format: .currency(code: "VND"))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.red)
                                        
                                    }
                                    .font(.headline)
                                    
                                    HStack {
                                        Text("Hợp đồng trả trước")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.gray)
                                        Spacer()
                                        
                                        NavigationLink {
                                            
                                        } label: {
                                            HStack {
                                                Text("Nhấn để xem")
                                                
                                                Image(systemName: "list.clipboard")
                                            }
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.blue)
                                        }
                                    }
                                    .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.white)
                                )
                            } header: {
                                Text("Thông tin trả trước")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 20)
                        }
                    }
                    .padding(.top)
                    .disabled(viewModel.isLoading)
                    .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                } else if !viewModel.isLoading {
                    CenterView {
                        Text("Tải dữ liệu thất bại")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                }
                
                LoadingCenterView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
            
            Divider()
            
            if let isReturnSoon = viewModel.preReturnResponseData?.order.orderDetails.first?.isReturnSoon, isReturnSoon == false {
                Button {
                    viewModel.showAlert(.remind, message: "Bạn có chắc chắn muốn yêu cầu trả cây trước hạn")
                } label: {
                    Text("Xác nhận trả trước")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.darkBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60, alignment: .top)
                        .padding()
                        .background(.white)
                }
            } else {
                Text("Đã yêu cầu trả trước")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60, alignment: .top)
                    .padding()
                    .background(.white)
            }
            
        }
        .background(Color(uiColor: UIColor.systemGray6))
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            viewModel.requestData(orderId: orderId, plantId: plantId)
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            switch viewModel.activeAlert {
            case .error:
                Alert(title: Text(viewModel.errorMessage ?? "Lỗi không xác định"))
                
            case .remind:
                Alert(title: Text(viewModel.errorMessage ?? "Lỗi không xác định"), primaryButton: .cancel(), secondaryButton: .default(Text("Xác nhận"), action: {
                    viewModel.confirmPreReturn(orderId: orderId)
                }))
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        HireOrderDetailHistoryScreen(orderId: 1, plantId: 2, viewModel: HireOrderViewModel())
    }
}
