//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI


enum OrderState: String, CaseIterable {
    case waitingForConfirm = "Chờ xác nhận"
    case waitingForPackage = "Chờ đóng gói"
    case waitingForDeliver = "Chờ giao hàng"
    case delivered = "Đã giao"
    case canceled = "Đã hủy"
    
    var flag: String {
        return self.rawValue
    }
}

struct OrderHistoryScreen: View {
    // MARK: - PROPERTY
    @Namespace private var animation
    
    @Binding var selectedOrderState: OrderState
    
    // MARK: - ENUM

    // MARK: - BODY
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Đơn hàng của bạn")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(OrderState.allCases, id: \.self) { orderState in
                        Button {
                            withAnimation {
                                selectedOrderState = orderState
                            }
                        } label: {
                            Text(orderState.flag)
                                .padding(8)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                        .foregroundColor(selectedOrderState == orderState ? .white : .primary)
                        .frame(width: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedOrderState == orderState ? Color.blue : Color.gray.opacity(0.2))
                        )
                        .padding(.vertical, 10)
                        .padding(orderState == .waitingForConfirm ? .leading : [])
                        .padding(orderState == .canceled ? .trailing : [])
                        .matchedGeometryEffect(id: orderState, in: animation, isSource: selectedOrderState == orderState)
                    }
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach (0 ..< 4) { _ in
                    DeliveredOrderRowView(image: Image("sample-bonsai"), itemName: "Cây cảnh phong thuỷ đã tạo kiểu", itemType: "Đã tạo kiểu", originalPrice: 190000, currentPrice: 150000, quantity: 1, totalPrice: 200000)
                }
                .padding(.top, 10)
                .background(Color(uiColor: UIColor.systemGray5))
            }
            .padding(.bottom, 30)
            
        }
        .background(.white)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .vertical)
    }
}

// MARK: - PREVIEW
#Preview {
    OrderHistoryScreen(selectedOrderState: .constant(.waitingForConfirm))
}
