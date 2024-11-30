//
//  HireOrderDetailsScreen.swift
//  Eppo
//
//  Created by Letter on 30/11/2024.
//

import SwiftUI

struct HireOrderDetailsScreen: View {
    @Bindable var viewModel: CartViewModel
    @State var selectedPaymentMethod: PaymentMethod = .cashOnDelivery
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Thanh Toán")
            ScrollView(.vertical) {
                VStack {
                    
                    List {
                        Picker("Chọn địa chỉ", selection: $viewModel.selectedAddress) {
                            ForEach(viewModel.addresses, id: \.self) { address in
                                Text(address.description)
                                    .tag(address as Address?)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .listRowSeparator(.hidden, edges: .bottom)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .listStyle(.inset)
                    .scrollDisabled(true)
                    
                    VStack {
                        ForEach(viewModel.selectedHireOrder) { plant in
                            // MARK: - NEED CHANGE
                            CartHireOrderItemView(viewModel: viewModel, plant: plant)
                                .background(Color.clear)
                        }
                        
                        Divider()
                            .padding(.horizontal, -14)
                            .padding(.vertical, 10)
                        
                        HStack {
                            Text("Tổng tiền")
                                .font(.subheadline)
                                .fontWeight(.regular)
                            Spacer()
                            Text(viewModel.totalRentalPrice() + viewModel.totalShippingFee, format: .currency(code: "VND"))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    
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
                    
                    Text(viewModel.totalRentalPrice() + viewModel.totalShippingFee, format: .currency(code: "VND"))
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
        .navigationBarBackButtonHidden()
        .background(Color(uiColor: UIColor.systemGray5))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getAddress()
//            viewModel.createOrderRequest = CreateOrderRequest(totalPrice: viewModel.totalPrice(), deliveryFee: 0, deliveryAddress: "ASDASD", paymentId: 1, orderDetails: viewModel.selectedOrder)
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
    HireOrderDetailsScreen(viewModel: CartViewModel())
}
