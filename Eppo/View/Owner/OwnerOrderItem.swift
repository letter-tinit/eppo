//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerOrderItem: View {
    // MARK: - PROPERTY
    @State var order: OwnerOrder
//    @Binding var orderStatus: String
//    @State var typeEcommerce: String = "Đơn mua"
    
//    init(order: OwnerOrder, orderStatus: String) {
//        self.order = order
//        self.orderStatus = orderStatus
//    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Đơn hàng số \(order.id)")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(getOrderStatus())
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
            }
            
            HStack {
                Text(getOrderType())
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.yellow)
                
                Spacer()
                
                Text((order.finalPrice).formatted(.currency(code: "VND")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
            }
            
            Text(order.deliveryAddress)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.black)
            
            if let recalDate = order.orderDetails.first?.rentalEndDate {
                Text("Ngày thu hồi: \(recalDate.formatted(.dateTime.day().month().year()))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.purple)
            }
            
        }
    }
    
    func getOrderStatus() -> String {
        switch order.status {
        case 1:
            if order.typeEcommerceId == 2 {
                return "Chưa thanh toán"
            } else {
                return "Chờ xác nhận"
            }
        case 2:
            return "Đang chuẩn bị hàng"
        case 3:
            return "Đang giao"
        case 4:
            return "Đã giao"
        case 5:
            return "Đã huỷ"
        case 6:
            return "Đã Thu hồi"
        default:
            return "Không xác định"
        }
    }
    
    func getOrderType() -> String {
        switch order.typeEcommerceId {
        case 1:
            return "Cây bán"
        case 2:
            return "Cây cho thuê"
        case 3:
            return "Cây đấu giá"
        default:
            return "Không xác định"
        }
    }
}
