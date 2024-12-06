//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerOrderItem: View {
    // MARK: - PROPERTY
    var order: OwnerOrder
    @State var orderStatus: String = "Đang giao"
    @State var typeEcommerce: String = "Đơn mua"

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Đơn hàng số \(order.id)")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(orderStatus)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.green)
            }
            
            HStack {
                Text(typeEcommerce)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.yellow)
                
                Spacer()
                
                Text((order.finalPrice + order.deliveryFee).formatted(.currency(code: "VND")))
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
        .onAppear {
            switch order.status {
            case 1:
                orderStatus = "Chờ xác nhận"
            case 2:
                orderStatus = "Đang chuẩn bị hàng"
            case 3:
                orderStatus = "Đang giao"
            case 4:
                orderStatus = "Đã giao"
            case 5:
                orderStatus = "Đã huỷ"
            case 6:
                orderStatus = "Đã Thu hồi"
            default:
                orderStatus = "Không xác định"
                break
            }
            
            switch order.typeEcommerceId {
            case 1:
                typeEcommerce = "Cây bán"
            case 2:
                typeEcommerce = "Cây cho thuê"
            case 3:
                typeEcommerce = "Cây đấu giá"
            default:
                typeEcommerce = "Không xác định"
                break
            }
        }
    }
}
