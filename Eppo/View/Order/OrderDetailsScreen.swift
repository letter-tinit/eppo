//
//  OrderDetailsScreen.swift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import SwiftUI

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cashOnDelivery = "Thanh toán khi nhận hàng"
    case myWallet = "Ví điện tử"
    var id: Self { self }
}

struct OrderDetailsScreen: View {
    @Bindable var viewModel: CartViewModel
    @State var selectedPaymentMethod: PaymentMethod = .cashOnDelivery
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                CustomHeaderView(title: "Thanh Toán")
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        Section {
                            HStack(alignment: .top) {
                                Text("Chọn địa chỉ")
                                
                                Picker("", selection: $viewModel.selectedAddress) {
                                    ForEach(viewModel.addresses, id: \.self) { address in
                                        Text(address.description)
                                            .tag(address as Address?)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .pickerStyle(.navigationLink)
                                .labelsHidden()
                            }
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        
                        LazyVStack {
//                            ForEach(viewModel.selectedOrder) { plant in
//                                CartOrderItemView(viewModel: viewModel, plant: plant)
//                                    .background(Color.clear)
//                            }
                            ForEach(viewModel.groupSelectedPlants, id: \.key) { group in
                                Section {
                                    ForEach(group.value) { plant in
                                        CartOrderItemView(viewModel: viewModel, plant: plant)
                                            .background(Color.clear)
                                    }
                                    .padding(8)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.horizontal)
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
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                    }
                                }                                
                            }
                        }
                        
                        List {
                            Picker(selection: $selectedPaymentMethod) {
                                ForEach(PaymentMethod.allCases, id: \.self) { paymentMethod in
                                    Text(paymentMethod.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                            } label: {
                                Text("Phương thức thanh toán")
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text(selectedPaymentMethod.rawValue)
                                
                                Spacer()
                                
                                Image(systemName: selectedPaymentMethod == .cashOnDelivery ? "coloncurrencysign.circle" : "creditcard.fill")
                                    .foregroundStyle(selectedPaymentMethod == .cashOnDelivery ? .green : .red)
                            }
                            .listRowSeparator(.hidden, edges: .bottom)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .listStyle(.inset)
                        .scrollDisabled(true)
                        
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom)
                
                HStack(alignment: .center, spacing: 20) {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Tổng thanh toán")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(viewModel.totalPrice() + viewModel.totalShippingFee, format: .currency(code: "VND"))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        guard var createOrderRequest = viewModel.createOrderRequest else {
                            return
                        }
                        
                        createOrderRequest.paymentId = selectedPaymentMethod == .cashOnDelivery ? 1 : 2
                        
                        viewModel.createOrderRequest = createOrderRequest
                        
                        viewModel.createOrder()
                    } label: {
                        Text("Đặt hàng")
                            .fontWeight(.medium)
                            .padding()
                            .frame(width: 140, height: 40)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(.white)
            }
            .disabled(viewModel.isLoading)
            
            CustomLoadingCenterView(title: "Đang thanh toán")
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .navigationBarBackButtonHidden()
        .background(Color(uiColor: UIColor.systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
//            viewModel.selectedOrder = viewModel.getSamplePlants()
            if viewModel.addresses.isEmpty {
                viewModel.getAddress()
            }
            viewModel.createOrderRequest = CreateOrderRequest(totalPrice: viewModel.totalPrice(), deliveryFee: 0, deliveryAddress: "ASDASD", paymentId: 1, orderDetails: viewModel.selectedOrder)
            viewModel.totalShippingFee = 0.0

        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text("\(viewModel.message)"), dismissButton: .cancel(Text("Đóng"), action: {
                self.dismiss()
            }))
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailsScreen(viewModel: CartViewModel())
    }
}
