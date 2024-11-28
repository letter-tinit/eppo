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
                                }
                            }
                    }
                }
                .listStyle(.inset)
                
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
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerOrderScreen()
}
