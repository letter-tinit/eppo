//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

enum CartState: String, CaseIterable {
    case buy = "Giỏ mua"
    case hire = "Giỏ thuê"
}

struct CartScreen: View {
    //    @State private var viewModel.orderDetails: [Plant] = []
    
    @State private var editMode: EditMode = .inactive
    
    @State private var isMoved = false
    
    @State var viewModel = CartViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            SingleHeaderView(title: "Giỏ hàng")
            if !viewModel.orderDetails.isEmpty {
                VStack(spacing: 0) {
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
                    .background(.black)
                    
                    List {
                        // MARK: - SECTION
                        Section {
                            ForEach(viewModel.groupedPlants, id: \.key) { group in
                                Section {
                                    ForEach(group.value) { plant in
                                        if let index = viewModel.orderDetails.firstIndex(where: { $0.id == plant.id }) {
                                            CartItemView(plant: $viewModel.orderDetails[index])
                                                .listRowInsets(EdgeInsets())
                                                .background(Color(uiColor: .systemGray6))
                                                .listRowSeparator(.hidden, edges: .bottom)
                                        }
                                    }
                                    .onDelete { indices in
                                        for index in indices {
                                            let plant = group.value[index]
                                            viewModel.deletePlant(id: plant.id)
                                        }
                                    }
                                } header: {
                                    NavigationLink {
                                        ShopPlantScreen(
                                            userName: group.value[0].plantUser?.fullName ?? "Không xác định",
                                            imageUrl: group.value[0].plantUser?.imageUrl ?? "Unknow",
                                            code: group.value[0].code
                                        )
                                    } label: {
                                        HStack(alignment: .bottom) {
                                            CustomCircleAsyncImage(imageUrl: group.value[0].plantUser?.imageUrl, size: 24)
                                            
                                            Text(group.value[0].plantUser?.fullName ?? "Không xác định")
                                                .font(.headline)
                                                .foregroundStyle(.darkBlue)
                                            
                                            Spacer()
                                        }
                                        .contentShape(Rectangle())
                                    }
                                }
                            }
                        }
                    }
                    .environment(\.editMode, $editMode)
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .listStyle(PlainListStyle())
                }
                
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
                
                VStack {
                    Text("Giỏ hàng trống")
                        .font(.headline)
                    Image(systemName: "cart.fill.badge.questionmark")
                        .font(.title)
                }
                .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .background(Color(uiColor: UIColor.systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            self.viewModel.orderDetails = UserSession.shared.cart
            self.viewModel.hireOrderDetails = UserSession.shared.hireCart
//            self.viewModel.orderDetails = viewModel.getSamplePlants()
        }
        .onChange(of: viewModel.orderDetails) {
            viewModel.selectedOrder = viewModel.orderDetails.filter { $0.isSelected }
        }
        .onChange(of: viewModel.hireOrderDetails) {
            viewModel.selectedHireOrder = viewModel.hireOrderDetails.filter { $0.isSelected }
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
    NavigationStack {
        CartScreen()
    }
}
