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
            
            CartStateHeader(selectedCart: $viewModel.selectedCart)
                .padding()
            switch viewModel.selectedCart {
            case .buy:
                if !viewModel.orderDetails.isEmpty {
                    VStack {
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
                        .clipShape(
                            .rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 8
                            )
                        )
                        .clipped()
                        
                        List {
                            // MARK: - SECTION
                            Section {
                                ForEach($viewModel.orderDetails, id: \.self) { plant in
                                    
                                    CartItemView(plant: plant)
                                        .listRowInsets(EdgeInsets())
                                        .background(Color(uiColor: .systemGray6))
                                        .listRowSeparator(.hidden, edges: .bottom)
                                }
                                .onDelete(perform: viewModel.deleteItem)
                            }
                        }
                        .environment(\.editMode, $editMode)
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        .listStyle(PlainListStyle())
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(uiColor: UIColor.systemGray4))
                    )
                    .clipped()
                    .padding(16)
                    
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
            case .hire:
                if !viewModel.hireOrderDetails.isEmpty {
                    VStack {
                        HStack {
                            Button {
                                viewModel.toggleAllHireSelections()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: viewModel.allHireItemsSelected ? "checkmark.square.fill" : "square")
                                        .fontWeight(.semibold)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(viewModel.allHireItemsSelected ? "Bỏ chọn tất cả" : "Chọn tất cả")
                                        .font(.headline)
                                }
                                .foregroundStyle(viewModel.allHireItemsSelected ? .green : .white)
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
                        .clipShape(
                            .rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 8
                            )
                        )
                        .clipped()
                        
                        List {
                            // MARK: - SECTION
                            Section {
                                ForEach($viewModel.hireOrderDetails, id: \.self) { plant in
                                    CartItemView(plant: plant)
                                        .listRowInsets(EdgeInsets())
                                        .background(Color(uiColor: .systemGray6))
                                        .listRowSeparator(.hidden, edges: .bottom)
                                }
                                .onDelete(perform: viewModel.deleteHireItem)
                            }
                        }
                        .environment(\.editMode, $editMode)
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        .listStyle(PlainListStyle())
                        
                        HStack(alignment: .center, spacing: 20) {
                            Image(systemName: "calendar")
                                .font(.title)
                                .overlay {
                                    DatePicker(selection: $viewModel.selectedDate,
                                               in: Date()...,
                                               displayedComponents: .date) {}
                                        .labelsHidden()
                                        .contentShape(Rectangle())
                                        .opacity(0.011)
                                }
                            
                            Divider()
                            
                            Spacer()
                            
                            Stepper(
                                value: $viewModel.numberOfMonth,
                                in: viewModel.range,
                                step: viewModel.step
                            ) {
                                Text("\(viewModel.numberOfMonth) Tháng")
                            }
                                
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                        .background(.teal)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 8,
                                bottomTrailingRadius: 8,
                                topTrailingRadius: 0
                            )
                        )
                        .clipped()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(uiColor: UIColor.systemGray4))
                    )
                    .clipped()
                    .padding(16)
                    
                    // MARK: - FOOTER
                    HStack(alignment: .top, spacing: 30) {
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Tổng giá tiền")
                                .foregroundStyle(.blue)
                            
                            Text(viewModel.totalRentalPrice(), format: .currency(code: "VND"))
                                .foregroundStyle(.red)
                        }
                        .font(.headline)
                        .padding(10)
                        
                        NavigationLink {
                            HireOrderDetailsScreen(viewModel: viewModel)
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
                
        }
        .background(Color(uiColor: UIColor.systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            self.viewModel.orderDetails = UserSession.shared.cart
            self.viewModel.hireOrderDetails = UserSession.shared.hireCart
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
    CartScreen()
}
