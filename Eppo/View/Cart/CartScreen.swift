//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CartScreen: View {
    // MARK: - PROPERTY
    @State private var checkedOutCart: [Cart] = []
    @State private var isAllChecked: Bool = false
    
    @State private var cartItems: [Cart] = [
        Cart(id: 1, cartName: "Cây Lan", isCheckedOut: false, originalPrice: 100000, currentPrice: 100000, quantity: 1, remainingQuantity: 3),
        Cart(id: 2, cartName: "Cây Mai Tứ Quý", isCheckedOut: false, originalPrice: 200000, currentPrice: 200000, quantity: 2, remainingQuantity: 3),
        Cart(id: 3, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3),
        Cart(id: 4, cartName: "Cây Xanh", isCheckedOut: false, originalPrice: 1250000, currentPrice: 1250000, quantity: 1, remainingQuantity: 3)
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center) {
            CustomHeaderView(title: "Giỏ hàng")
            
            if !cartItems.isEmpty {
                ScrollView(.vertical) {
                    Section {
                        ForEach($cartItems) { $cartItem in
                            CartItemView(
                                cartItem: $cartItem,
                                onRemove: { removeCart(item: cartItem) },
                                onToggleCheck: { toggleItemChecked(for: cartItem) }
                            )
//                            HStack(alignment: .top, spacing: 10) {
//                                Button {
//                                    toggleItemChecked(for: cartItem)
//                                    
//                                    print(checkedOutCart)
//                                } label: {
//                                    Image(systemName: cartItem.isCheckedOut ? "checkmark.square.fill" : "square")
//                                        .fontWeight(.semibold)
//                                        .frame(width: 20, height: 20)
//                                        .foregroundStyle(.green)
//                                }
//                                
//                                // Item Image
//                                Image("sample-bonsai")
//                                    .resizable()
//                                    .frame(width: 90, height: 90)
//                                    .clipped()
//                                    .border(Color(uiColor: UIColor.systemGray4), width: 1.2)
//                                
//                                VStack(alignment: .leading) {
//                                    HStack {
//                                        Text(cartItem.cartName)
//                                            .font(.headline)
//                                            .lineLimit(1)
//                                        
//                                        Spacer()
//                                        
//                                        Button {
//                                            removeCart(item: cartItem)
//                                        } label: {
//                                            Image(systemName: "trash")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 16)
//                                                .foregroundStyle(.red)
//                                        }
//                                    }
//                                    
//                                    HStack {
//                                        Text("Đổi ý 15 ngày")
//                                            .font(.caption)
//                                            .padding(3)
//                                            .border(.mint)
//                                            .foregroundStyle(.mint)
//                                            .lineLimit(1)
//                                        
//                                        Stepper(value: $cartItems[cartItems.firstIndex(where: { $0.id == cartItem.id })!].quantity, in: 1...cartItems[cartItems.firstIndex(where: { $0.id == cartItem.id })!].remainingQuantity) {}
//                                    }
//                                    
//                                    HStack {
//                                        Text(cartItem.currentPrice, format: .currency(code: "VND"))
//                                            .fontWeight(.semibold)
//                                            .foregroundStyle(.red)
//                                            .font(.subheadline)
//                                        
//                                        Text(cartItem.originalPrice, format: .currency(code: "VND"))
//                                            .font(.subheadline)
//                                            .foregroundStyle(.black)
//                                            .strikethrough()
//                                        
//                                        Spacer()
//                                        
//                                        Text("SL: \(cartItem.quantity)")
//                                            .fontWeight(.semibold)
//                                            .foregroundStyle(.black)
//                                            .font(.subheadline)
//                                    }
//                                }
//                                
//                            }
//                            .padding(10)
                        }
//                        .background(Color(uiColor: UIColor.systemGray6))
                    } header: {
                        HStack {
                            Text("Giỏ hàng sản phẩm mua")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
            } else {
                Spacer()
                
                Text("Giỏ hàng trống")
                    .background(.red)
                
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .vertical)
    }
    
    func totalPrice() -> Double {
        return checkedOutCart.reduce(0) { $0 + $1.currentPrice }
    }
    
    func formatPrice(_ price: Double) -> String {
        return String(format: "₫%.2f", price)
    }
    
    func toggleItemChecked(for cartItem: Cart) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].isCheckedOut.toggle()
            if cartItems[index].isCheckedOut {
                checkedOutCart.append(cartItems[index])
            } else {
                checkedOutCart.removeAll { $0.id == cartItems[index].id }
            }
            checkIfAllSelected()
        }
    }
    
    func toggleCheckAll() {
        isAllChecked.toggle()
        
        if isAllChecked {
            // Chọn tất cả các mục
            for i in cartItems.indices {
                cartItems[i].isCheckedOut = true
            }
            checkedOutCart = cartItems // Đưa tất cả vào giỏ hàng đã chọn
        } else {
            // Bỏ chọn tất cả các mục
            for i in cartItems.indices {
                cartItems[i].isCheckedOut = false
            }
            checkedOutCart.removeAll() // Xóa tất cả khỏi giỏ hàng đã chọn
        }
    }
    
    func checkIfAllSelected() {
        isAllChecked = cartItems.allSatisfy { $0.isCheckedOut }
    }
    
    func removeCart(at index: Int) {
        // Xóa khỏi checkedOutCart nếu mục đang được chọn
        if cartItems[index].isCheckedOut {
            checkedOutCart.removeAll { $0.id == cartItems[index].id }
        }
        // Xóa mục khỏi options
        cartItems.remove(at: index)
    }
    
    func removeCart(item: Cart) {
        // Remove from checkedOutCart if selected
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if cartItems[index].isCheckedOut {
                checkedOutCart.removeAll { $0.id == cartItems[index].id }
            }
            // Remove item from cartItems safely
            cartItems.remove(at: index)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}


//        Button(action: {
//            toggleCheckAll()
//        }) {
//            Text(isAllChecked ? "Uncheck All" : "Check All")
//                .padding()
//                .background(isAllChecked ? Color.red : Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//        .padding()



//            Text("Total: \(formatPrice(totalPrice()))")
