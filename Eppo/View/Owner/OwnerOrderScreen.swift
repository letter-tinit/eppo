//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerOrderScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = OwnerOrderViewModel()
    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {
            SingleHeaderView(title: "Đơn hàng")
            
            ZStack {
                List {
                    ForEach (viewModel.ownerOrders) { ownerOrder in
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
                                    } label: {
                                        Text("Xác nhận")
                                    }
                                    .tint(.red)
                                    // MARK: - Các trường hợp khác khôn có hành động
                                } else {
                                    Button {
                                        // DO NOTHING
                                    } label: {
                                        Text("Bỏ qua")
                                    }
                                    .tint(.gray)
                                }
                            }
                    }
                }
                .listStyle(.inset)
                
                CenterView {
                    Text("Bạn chưa có đơn hàng nào cả!")
                }
                .opacity((viewModel.ownerOrders.isEmpty && !viewModel.isLoading) ? 1 : 0)
                
                LoadingCenterView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.isStatusPickerPopup, content: {
            Text("A")
                .presentationDetents([.height(200)])
        })
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getOwnerOrders()
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerOrderScreen()
}
