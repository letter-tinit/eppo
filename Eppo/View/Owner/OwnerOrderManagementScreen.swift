//
// Created by Treasure Letter ♥
// 
// https://github.com/letter-tinit
//

import SwiftUI

struct OwnerOrderManagementScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = OwnerOrderViewModel()

    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 0) {
            SingleHeaderView(title: "Quản lý đơn hàng")
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(OwnerOrderState.allCases, id: \.self) { orderState in
                        Button {
                            withAnimation {
                                viewModel.orderState = orderState
                            }
                        } label: {
                            Text(orderState.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(viewModel.orderState == orderState ? .white : .black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundStyle(viewModel.orderState == orderState ? .blue : Color(uiColor: .systemGray6))
                                )
                                .padding(4)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .frame(height: 50)
            
            ZStack {
                List {
                    ForEach (viewModel.ownerOrders, id: \.self) { ownerOrder in
                        OwnerOrderItem(order: ownerOrder)
                            .swipeActions {
                                if ownerOrder.status == 3 {
                                    NavigationLink {
                                        DeliveriteConfirmedScreen(orderId: ownerOrder.id)
                                    } label: {
                                        Text("Xác nhận giao")
                                    }
                                    .tint(.orange)
                                } else if ownerOrder.status == 2 {
                                    Button {
                                        viewModel.finishPrepare(orderId: ownerOrder.id)
                                    } label: {
                                        Text("Chuẩn bị xong")
                                    }
                                    .tint(.green)
                                    // MARK: - Chỉ đơn thuê mới được thu hồi
                                } else if ownerOrder.status == 4 && ownerOrder.typeEcommerceId == 2 {
                                    NavigationLink {
                                        DeliveriteConfirmedScreen(orderId: ownerOrder.id, isRefund: true)
                                    } label: {
                                        Text("Thu hồi")
                                    }
                                    .tint(.purple)
                                    // MARK: - Đơn thuê tự động xác nhận khi chưa thanh toán nên bị exclude
                                } else if ownerOrder.status == 1 && ownerOrder.typeEcommerceId != 2 {
                                    Button {
                                        // chuyển trạng thái từ 1 sang 2
                                        viewModel.confirmed(orderId: ownerOrder.id)
                                    } label: {
                                        Text("Xác nhận")
                                    }
                                    .tint(.red)
                                    // MARK: - Các trường hợp khác khôn có hành động
                                }
                            }
                    }
                }
                .listStyle(.inset)
                .disabled(viewModel.isLoading)
                
                CenterView {
                    Text("Bạn chưa có đơn hàng nào cả!")
                }
                .opacity((viewModel.ownerOrders.isEmpty && !viewModel.isLoading) ? 1 : 0)
                
                LoadingCenterView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getOwnerOrdersByState()
        }
        .onChange(of: viewModel.orderState, {
            viewModel.getOwnerOrdersByState()
        })
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerOrderManagementScreen()
}
