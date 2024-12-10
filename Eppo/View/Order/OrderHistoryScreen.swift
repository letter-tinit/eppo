//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI


// MARK: - ENUM

enum OrderState: String, CaseIterable {
    case waitingForConfirm = "Chờ xác nhận"
    case waitingForPackage = "Đang chuẩn bị hàng"
    case waitingForDeliver = "Đang giao"
    case delivered = "Đã giao"
    case canceled = "Đã hủy"
    
    var flag: String {
        return self.rawValue
    }
}

struct OrderHistoryScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = BuyOrderViewModel()
    @Namespace private var animation
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Đơn hàng của bạn")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(OrderState.allCases, id: \.self) { orderState in
                        Button {
                            withAnimation {
                                viewModel.selectedOrderState = orderState
                            }
                        } label: {
                            Text(orderState.flag)
                                .padding(10)
                                .foregroundColor(viewModel.selectedOrderState == orderState ? .white : .primary)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(viewModel.selectedOrderState == orderState ? Color.blue : Color.gray.opacity(0.2))
                                )
                        }                        
                        .padding(.vertical, 10)
                        .padding(orderState == .waitingForConfirm ? .leading : [])
                        .padding(orderState == .canceled ? .trailing : [])
                        .matchedGeometryEffect(id: orderState, in: animation, isSource: viewModel.selectedOrderState == orderState)
                    }
                }
            }
            
            if viewModel.isLoading {
                CenterView {
                    ProgressView("Đang tải")
                }
            } else if !viewModel.orders.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach (viewModel.orders) { order in
                        BuyOrderRowView(viewModel: viewModel, orderId: order.id, totalPrice: order.finalPrice, deliveriteFree: order.deliveryFee, orderDetails: order.orderDetails, isCancellable: viewModel.selectedOrderState == .waitingForConfirm || viewModel.selectedOrderState == .waitingForPackage, isReceived: viewModel.selectedOrderState == .waitingForDeliver)
                            .padding(10)
                    }
                    .background(Color(uiColor: UIColor.systemGray5))
                }
                .padding(.bottom, 30)
            } else {
                CenterView {
                    Text("Không tìm thấy dữ liệu")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
            }
        }
        .background(.white)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            viewModel.getBuyOrderHistory()
        }
        .onChange(of: viewModel.selectedOrderState) {
            viewModel.getBuyOrderHistory()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    OrderHistoryScreen()
}
