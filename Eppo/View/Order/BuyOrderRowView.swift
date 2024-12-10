//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct BuyOrderRowView: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: BuyOrderViewModel
    var orderId: Int
    var totalPrice: Double
    var deliveriteFree: Double
    
    let orderDetails: [BuyHistoryOrderDetail]
    
    var isCancellable: Bool = false
    var isReceived: Bool = false

    // MARK: - BODY
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(orderDetails) { orderDetail in
                HStack(alignment: .center) {
                    CustomAsyncImage(imageUrl: orderDetail.plant.mainImage, width: 60, height: 60)
                    
                    VStack(alignment: .leading) {
                        Text(orderDetail.plant.name)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text(orderDetail.plant.finalPrice, format: .currency(code: "VND"))
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack(alignment: .bottom) {
                // Quantity
                VStack(alignment: .leading) {
                    Text("Số sản phẩm: \(orderDetails.count)")
                    Text("Phí ship: \(deliveriteFree.formatted(.currency(code: "VND")))")
                }
                .font(.subheadline)
            .foregroundStyle(.gray)
                
                Spacer()
                
                Text("Thành tiền:")
                    .font(.subheadline)
                    .foregroundStyle(.black)

                
                // Total Price
                Text(totalPrice, format: .currency(code: "VND"))
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 10)

            if isCancellable {
                Button {
                    viewModel.activeAlert = .remind
                    viewModel.isAlertShowing = true
                } label: {
                    Text("Huỷ đơn hàng")
                        .frame(width: 140, height: 40)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.red)
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
            }
            
            if isReceived {
                Button {
                    viewModel.receiveOrder(orderId: orderId, newStatus: 4)
                } label: {
                    Text("Đã nhận hàng")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(width: 140, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.darkBlue)
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
            }
        }
        .scaledToFit()
        .padding(.vertical)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .alert(isPresented: $viewModel.isAlertShowing) {
            switch viewModel.activeAlert {
            case .error:
                return Alert(title: Text(viewModel.errorMessage ?? "Lỗi không xác định"), dismissButton: .cancel())
            case .remind:
                return Alert(title: Text("Nhắc nhở"), message: Text("Bạn chỉ có thể huỷ 3 đơn/ngày"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
                    self.viewModel.cancelOrder(id: orderId)
                }))
            }
        }
//        .alert(isPresented: $viewModel.isAlertShowing) {
//            Alert(title: Text("Nhắc nhở"), message: Text("Bạn chỉ có thể huỷ 3 đơn/ngày"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
//                self.viewModel.cancelOrder(id: orderId)
//            }))
//        }
    }
}

// MARK: - PREVIEW
//#Preview {
//    BuyOrderRowView(totalPrice: 2001, deliveriteFree: 0)
//}
