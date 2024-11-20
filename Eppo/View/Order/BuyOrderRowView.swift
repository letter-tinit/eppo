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
    
    // MARK: - BODY
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(orderDetails) { orderDetail in
                HStack(alignment: .center) {
                    // Item Image
                    Image("sample-bonsai")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
                    
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
                    viewModel.cancelOrder(id: orderId)
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
        }
        .scaledToFit()
        .padding(.vertical)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - PREVIEW
//#Preview {
//    BuyOrderRowView(totalPrice: 2001, deliveriteFree: 0)
//}
