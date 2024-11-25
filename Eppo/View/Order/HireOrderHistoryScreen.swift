//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI


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
                    ForEach(OrderState.allCases, id: \.self) { orderState in
                        Button {
                            withAnimation {
                                viewModel.selectedOrderState = orderState
                            }
                        } label: {
                            Text(orderState.flag)
                                .padding(8)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .foregroundColor(viewModel.selectedOrderState == orderState ? .white : .primary)
                        .frame(width: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.selectedOrderState == orderState ? Color.blue : Color.gray.opacity(0.2))
                        )
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
                    ForEach (viewModel.orders) { ordersHireHistoryOrder in
                        if let orderDetail = ordersHireHistoryOrder.orderDetails.first
                        {
                            if ordersHireHistoryOrder.paymentStatus == "Chưa thanh toán"{
                                NavigationLink {
                                    ReviewRentalPlantScreen(viewModel: ReviewRentalPlantViewModel(plant: orderDetail.plant, orderId: ordersHireHistoryOrder.id, rentTotalPrice: ordersHireHistoryOrder.finalPrice, rentTotalAmount: ordersHireHistoryOrder.finalPrice + ordersHireHistoryOrder.deliveryFee, deliveriteFree: ordersHireHistoryOrder.deliveryFee))
                                } label: {
                                    HireOrderRowView(viewModel: viewModel, id: ordersHireHistoryOrder.id, totalPrice: ordersHireHistoryOrder.finalPrice, deliveriteFree: ordersHireHistoryOrder.deliveryFee, numberOfMonth: orderDetail.numberMonth, orderDetail: orderDetail, isCancellable: viewModel.selectedOrderState == .waitingForConfirm)
                                        .foregroundStyle(.black)
                                }
                            } else {
                                HireOrderRowView(viewModel: viewModel, id: ordersHireHistoryOrder.id, totalPrice: ordersHireHistoryOrder.finalPrice, deliveriteFree: ordersHireHistoryOrder.deliveryFee, numberOfMonth: orderDetail.numberMonth, orderDetail: orderDetail, isCancellable: viewModel.selectedOrderState == .waitingForConfirm)
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
