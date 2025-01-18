//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct DeliveredHireOrderRowView: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: HireOrderViewModel
    
    var id: Int

    var totalPrice: Double
    var paymentStatus: String
    var deliveriteFree: Double
    var deposit: Double
    var numberOfMonth: Int
    let orderDetail: HireHistoryOrderDetail
    var isCancellable: Bool = false
    var isReceived: Bool = false

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                CustomAsyncImage(imageUrl: orderDetail.plant.mainImage, width: 84, height: 84)
                
                VStack(alignment: .leading) {
                    Text(orderDetail.plant.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(orderDetail.plant.finalPrice, format: .currency(code: "VND"))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                    
                    Text("Ngày thuê: \(orderDetail.rentalStartDate.formatted(date: .numeric, time: .omitted))")
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        .font(.subheadline)
                    
                    Text("Ngày trả: \(orderDetail.rentalEndDate.formatted(date: .numeric, time: .omitted))")
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
            
            HStack(alignment: .bottom) {
                // Quantity
                VStack(alignment: .leading) {
                    Text(paymentStatus)
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                    Text("Số tháng: \(numberOfMonth)")
                        .foregroundStyle(.gray)
                    Text("Tiền cọc: \(deposit.formatted(.currency(code: "VND")))")
                        .foregroundStyle(.gray)
                    Text("Phí vận chuyển: \(deliveriteFree.formatted(.currency(code: "VND")))")
                        .foregroundStyle(.gray)
                    Text("Thành tiền: \(totalPrice.formatted(.currency(code: "VND")))")
                        .foregroundStyle(.black)
                }
                .font(.subheadline)
                
                Spacer()
            }
            .padding(.horizontal, 10)
            
            NavigationLink {
                HireOrderDetailHistoryScreen(orderId: id, plantId: orderDetail.plant.id, viewModel: viewModel)
            } label: {
                Text("Yêu cầu trả trước")
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
        .scaledToFit()
        .padding(.vertical)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 10)
        .alert(isPresented: $viewModel.isAlertShowing) {
            switch viewModel.activeAlert {
            case .error:
                return Alert(title: Text(viewModel.errorMessage ?? "Lỗi không xác định"), dismissButton: .cancel())
            case .remind:
                return Alert(title: Text("Nhắc nhở"), message: Text("Bạn chỉ có thể huỷ 3 đơn/ngày"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
                    self.viewModel.cancelOrder(id: id)
                }))
            }
        }
//        .alert(isPresented: $viewModel.isAlertShowing) {
//            Alert(title: Text("Nhắc nhở"), message: Text("Bạn chỉ có thể huỷ 3 đơn/ngày"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
//                self.viewModel.cancelOrder(id: id)
//            }))
//        }
    }
}

// MARK: - PREVIEW
//#Preview {
//    DeliveredHireOrderRowView(totalPrice: 2001, deliveriteFree: 0, numberOfMonth: 3, plant: Plant(id: 1, name: "Rose", price: 15.99, description: "A beautiful red rose."))
//}
