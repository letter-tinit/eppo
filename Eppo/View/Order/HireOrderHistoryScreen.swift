//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

enum HireOrderState: String, CaseIterable {
    case waitingForConfirm = "Chờ xác nhận"
    case waitingForPackage = "Đang chuẩn bị hàng"
    case waitingForDeliver = "Đang giao"
    case delivered = "Đã giao"
    case canceled = "Đã hủy"
    case refunded = "Đã thu hồi"

    var flag: String {
        return self.rawValue
    }
}

struct HireOrderHistoryScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = HireOrderViewModel()
    
    @Namespace private var animation
    // MARK: - BODY
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Đơn hàng Thuê")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(HireOrderState.allCases, id: \.self) { orderState in
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
                        .padding(orderState == .refunded ? .trailing : [])
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
                    ForEach (viewModel.orders) { ordersHireHistoryOrder in
                        if let orderDetail = ordersHireHistoryOrder.orderDetails.first
                        {
                            if ordersHireHistoryOrder.paymentStatus == "Chưa thanh toán" {
                                NavigationLink {
                                    ReviewRentalPlantScreen(viewModel: ReviewRentalPlantViewModel(plant: orderDetail.plant, orderId: ordersHireHistoryOrder.id, rentTotalPrice: ordersHireHistoryOrder.finalPrice, rentTotalAmount: ordersHireHistoryOrder.finalPrice + ordersHireHistoryOrder.deliveryFee, deliveriteFree: ordersHireHistoryOrder.deliveryFee, deliveryAddress: ordersHireHistoryOrder.deliveryAddress))
                                } label: {
                                    HireOrderRowView(viewModel: viewModel, id: ordersHireHistoryOrder.id, totalPrice: ordersHireHistoryOrder.finalPrice, paymentStatus: ordersHireHistoryOrder.paymentStatus, deliveriteFree: ordersHireHistoryOrder.deliveryFee, numberOfMonth: orderDetail.numberMonth, orderDetail: orderDetail, isCancellable: viewModel.selectedOrderState == .waitingForConfirm || viewModel.selectedOrderState == .waitingForPackage, isReceived: viewModel.selectedOrderState == .waitingForDeliver)
                                        .foregroundStyle(.black)
                                }
                            } else {
                                HireOrderRowView(viewModel: viewModel, id: ordersHireHistoryOrder.id, totalPrice: ordersHireHistoryOrder.finalPrice, paymentStatus: ordersHireHistoryOrder.paymentStatus, deliveriteFree: ordersHireHistoryOrder.deliveryFee, numberOfMonth: orderDetail.numberMonth, orderDetail: orderDetail, isCancellable: viewModel.selectedOrderState == .waitingForConfirm || viewModel.selectedOrderState == .waitingForPackage, isReceived: viewModel.selectedOrderState == .waitingForDeliver)
                            }
                        }
                    }
                    .padding(.vertical, 10)
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
            viewModel.getHireOrderHistory()
        }
        .onChange(of: viewModel.selectedOrderState) {
            viewModel.getHireOrderHistory()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HireOrderHistoryScreen()
}
