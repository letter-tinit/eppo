//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CartScreen: View {
    //    @State private var viewModel.orderDetails: [Plant] = []
    
    @State private var editMode: EditMode = .inactive
    
    @State var viewModel = CartViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SingleHeaderView(title: "Giỏ hàng")
            
            if !viewModel.orderDetails.isEmpty {
                HStack {
                    Button {
                        viewModel.toggleAllSelections()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.allItemsSelected ? "checkmark.square.fill" : "square")
                                .fontWeight(.semibold)
                                .frame(width: 20, height: 20)
                            
                            Text(viewModel.allItemsSelected ? "Bỏ chọn tất cả" : "Chọn tất cả")
                                .font(.headline)
                        }
                        .foregroundStyle(viewModel.allItemsSelected ? .green : .white)
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
                        ForEach($viewModel.orderDetails, id: \.self) { plant in
                            CartItemView(plant: plant)
                                .listRowInsets(EdgeInsets())
                                .background(Color.clear)
                        }
                        .onDelete(perform: viewModel.deleteItem)
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
                        
                        Text(viewModel.totalPrice(), format: .currency(code: "VND"))
                            .foregroundStyle(.red)
                    }
                    .font(.headline)
                    .padding(10)
                    
                    NavigationLink {
                        OrderDetailsScreen(viewModel: viewModel)
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
        .onAppear {
            self.viewModel.orderDetails = UserSession.shared.cart
        }
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
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
