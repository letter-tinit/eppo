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
                                } else if ownerOrder.status == 4 && ownerOrder.typeEcommerceId == 2 {
                                    NavigationLink {
                                        DeliveriteConfirmedScreen(orderId: ownerOrder.id, isRefund: true)
                                    } label: {
                                        Text("Thu hồi")
                                    }
                                    .tint(.green)
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
