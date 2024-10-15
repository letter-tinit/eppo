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
    @State private var editMode: EditMode = .inactive
    
    @State private var cartItems: [Cart] = [
        Cart(id: 1, cartName: "Cây Lan", isCheckedOut: false, originalPrice: 100000, currentPrice: 100000, quantity: 1, remainingQuantity: 3, isHireable: false),
        Cart(id: 2, cartName: "Cây Mai Tứ Quý", isCheckedOut: false, originalPrice: 200000, currentPrice: 200000, quantity: 2, remainingQuantity: 3, isHireable: false),
        Cart(id: 3, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: false),
        Cart(id: 4, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: false),
        Cart(id: 5, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: true),
        Cart(id: 6, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: true),
        Cart(id: 7, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: true),
        Cart(id: 8, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: true),
        Cart(id: 9, cartName: "Cây Cổ thụ", isCheckedOut: false, originalPrice: 250000, currentPrice: 250000, quantity: 1, remainingQuantity: 3, isHireable: true),
        Cart(id: 10, cartName: "Cây Xanh", isCheckedOut: false, originalPrice: 1250000, currentPrice: 1250000, quantity: 1, remainingQuantity: 3, isHireable: true)
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center) {
            SingleHeaderView(title: "Giỏ hàng")
            
            if !cartItems.isEmpty {
                List {
                    // MARK: - SECTION
                    Section {
                        ForEach(cartItems.indices, id: \.self) { index in
                            CartItemView(
                                cartItem: $cartItems[index],
                                onToggleCheck: {
                                    print("Before toggle: \(cartItems.map { $0.isCheckedOut })") // Kiểm tra trạng thái trước
                                    toggleItemChecked(at: index)
                                    print("After toggle: \(cartItems.map { $0.isCheckedOut })") // Kiểm tra trạng thái sau
                                    
                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .background(Color.clear)
                        }
                        .onDelete(perform: deleteItems) // Sử dụng onDelete
                        //                    .onMove(perform: moveItems)
                    } header: {
                        HStack {
                            Button {
                                toggleCheckAll()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: isAllChecked ? "checkmark.square.fill" : "square")
                                        .fontWeight(.semibold)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(isAllChecked ? "Bỏ chọn tất cả" : "Chọn tất cả")
                                        .font(.headline)
                                }
                                .foregroundStyle(isAllChecked ? .green : .white)
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    editMode = (editMode == .active) ? .inactive : .active
                                }
                            } label: {
                                Image(systemName: editMode == .active ? "checkmark" : "square.and.pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 26)
                                    .fontWeight(.bold)
                                    .foregroundStyle(editMode == .active ? .green : .white)
                                //                                    .padding(.bottom, 20)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(.gray)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 10,
                                topTrailingRadius: 10
                            )
                        )
                    }
                    .listRowInsets(EdgeInsets())
                }
                .environment(\.editMode, $editMode)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(8)
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                .listStyle(PlainListStyle())
                
                // MARK: - FOOTER
                HStack(alignment: .top, spacing: 30) {
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Tổng giá tiền")
                            .foregroundStyle(.blue)
                        
                        Text(totalPrice(), format: .currency(code: "VND"))
                            .foregroundStyle(.red)
                    }
                    .font(.headline)
                    .padding(10)
                    
                    Button {
                        
                    } label: {
                        Text("Thanh Toán")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxHeight: .infinity)
                            .padding(10)
                            .background(.red)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 60, alignment: .top)
                .background(.lightBlue)
            } else {
                Spacer()
                
                Text("Giỏ hàng trống")
                    .background(.red)
            }
            
            Spacer()
        }
        .background(Color(uiColor: UIColor.systemGray6))
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - HEADER VIEW
    var headerView: some View {
        HStack {
            Text("Các mục trong giỏ hàng")
                .font(.headline)
                .foregroundColor(.white) // Màu chữ
                .padding() // Khoảng cách cho chữ
            Spacer()
        }
        .background(Color.blue) // Màu nền cho header
    }
    
    // MARK: - FUNCTIONS
    func removeCart(at index: Int) {
        guard index < cartItems.count else { return } // Kiểm tra chỉ số
        if cartItems[index].isCheckedOut {
            checkedOutCart.removeAll { $0.id == cartItems[index].id }
        }
        cartItems.remove(at: index) // Xóa mục khỏi cartItems
    }
    
    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + ($1.isCheckedOut ? $1.currentPrice * Double($1.quantity) : 0) }
    }
    
    func formatPrice(_ price: Double) -> String {
        return String(format: "₫%.2f", price)
    }
    
    func toggleCheckAll() {
        isAllChecked.toggle()
        
        for i in cartItems.indices {
            cartItems[i].isCheckedOut = isAllChecked
        }
        
        // Cập nhật checkedOutCart
        if isAllChecked {
            checkedOutCart = cartItems // Đưa tất cả vào checkedOutCart
        } else {
            checkedOutCart.removeAll() // Xóa tất cả khỏi checkedOutCart
        }
    }
    
    func toggleItemChecked(at index: Int) {
        // Kiểm tra chỉ số
        guard index < cartItems.count else { return }
        
        // Đảo ngược trạng thái
        cartItems[index].isCheckedOut.toggle()
        
        // Cập nhật checkedOutCart
        if cartItems[index].isCheckedOut {
            checkedOutCart.append(cartItems[index])
        } else {
            checkedOutCart.removeAll { $0.id == cartItems[index].id }
        }
        
        // Cập nhật trạng thái isAllChecked
        isAllChecked = cartItems.allSatisfy { $0.isCheckedOut }
    }
    
    func checkIfAllSelected() {
        isAllChecked = cartItems.allSatisfy { $0.isCheckedOut }
    }
    
    func deleteItems(at offsets: IndexSet) {
        // Xóa mục dựa trên chỉ số trong IndexSet
        cartItems.remove(atOffsets: offsets)
        print(cartItems)
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        cartItems.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
