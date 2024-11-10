//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CartScreen: View {
    // MARK: - PROPERTY
    @State var orderDetails: [Plant] = [
        Plant(id: 1, name: "Aloe Vera", price: 10.99, description: "A succulent plant with healing properties."),
        Plant(id: 2, name: "Snake Plant", price: 15.49, description: "A hardy plant that purifies air."),
        Plant(id: 3, name: "Spider Plant", price: 8.99, description: "A popular houseplant that's easy to care for."),
        Plant(id: 4, name: "Peace Lily", price: 12.99, description: "An elegant plant with beautiful white flowers."),
        Plant(id: 5, name: "Fiddle Leaf Fig", price: 20.0, description: "A trendy plant with large, lush leaves."),
        Plant(id: 6, name: "Fiddle Leaf Fig", price: 20.0, description: "A trendy plant with large, lush leaves.")
    ]
    
    @State private var editMode: EditMode = .inactive
    
    // Computed property to check if all items are selected
    private var allItemsSelected: Bool {
        orderDetails.allSatisfy { $0.isSelected }
    }
    
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SingleHeaderView(title: "Giỏ hàng")
            
            if !orderDetails.isEmpty {
                HStack {
                    Button {
                        toggleAllSelections()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: allItemsSelected ? "checkmark.square.fill" : "square")
                                .fontWeight(.semibold)
                                .frame(width: 20, height: 20)
                            
                            Text(allItemsSelected ? "Bỏ chọn tất cả" : "Chọn tất cả")
                                .font(.headline)
                        }
                        .foregroundStyle(allItemsSelected ? .green : .white)
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
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.red)
                
                List {
                    // MARK: - SECTION
                    Section {
                        ForEach($orderDetails, id: \.self) { plant in
                            CartItemView(plant: plant)
                                .listRowInsets(EdgeInsets())
                                .background(Color.clear)
                        }
                        .onDelete(perform: deleteItem)
//                        .listRowSeparator(.hidden)
                    }
                }
                .environment(\.editMode, $editMode)
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
    
    func deleteItem(at offsets: IndexSet) {
        orderDetails.remove(atOffsets: offsets)
        print(orderDetails)
    }
    
    func toggleAllSelections() {
        let shouldSelectAll = !allItemsSelected
        orderDetails = orderDetails.map { plant in
            var updatedPlant = plant
            updatedPlant.isSelected = shouldSelectAll
            return updatedPlant
        }
    }
    
    func totalPrice() -> Double {
        return orderDetails
            .filter { $0.isSelected }
            .map { $0.price }
            .reduce(0, +)
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
