//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct HireOrderRowView: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: HireOrderViewModel
    
    var id: Int

    var totalPrice: Double
    var deliveriteFree: Double
    var numberOfMonth: Int
    let orderDetail: HireHistoryOrderDetail
    var isCancellable: Bool = false

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // Item Image
                Image("sample-bonsai")
                    .resizable()
                    .frame(width: 80, height: 80)
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
                    Text("Số tháng: \(numberOfMonth)")
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
                    viewModel.isAlertShowing = true
                } label: {
                    Text("Huỷ đơn hàng")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
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
        .padding(.horizontal, 10)
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text("Nhắc nhở"), message: Text("Bạn chỉ có thể huỷ 3 đơn/ngày"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
                self.viewModel.cancelOrder(id: id)
            }))
        }
    }
}

// MARK: - PREVIEW
//#Preview {
//    HireOrderRowView(totalPrice: 2001, deliveriteFree: 0, numberOfMonth: 3, plant: Plant(id: 1, name: "Rose", price: 15.99, description: "A beautiful red rose."))
//}
