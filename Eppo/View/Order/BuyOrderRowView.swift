//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct BuyOrderRowView: View {
    // MARK: - PROPERTY
    var totalPrice: Double
    var deliveriteFree: Double
    var isCancellable: Bool = false
    
    let plants: [Plant] = [
        Plant(id: 1, name: "Rose", price: 15.99, description: "A beautiful red rose."),
        Plant(id: 2, name: "Tulip", price: 10.50, description: "A vibrant spring tulip."),
//        Plant(id: 3, name: "Orchid", price: 25.75, description: "An elegant and exotic orchid.")
    ]
    
    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(plants) { plant in
                HStack(alignment: .center) {
                    // Item Image
                    Image("sample-bonsai")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
                    
                    VStack(alignment: .leading) {
                        Text(plant.name)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text(plant.price, format: .currency(code: "VND"))
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
                    Text("Số sản phẩm: \(plants.count)")
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
        .padding(.horizontal, 10)
    }
}

// MARK: - PREVIEW
#Preview {
    BuyOrderRowView(totalPrice: 2001, deliveriteFree: 0)
}
