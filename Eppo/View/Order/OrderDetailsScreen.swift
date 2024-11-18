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
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Thanh Toán")
            ScrollView(.vertical) {
                VStack {
                    AddressOrderView()
                        .padding(.horizontal)
                    
                    VStack {
                        ForEach(viewModel.selectedOrder) { plant in
                            OrderItemView(plant: plant)
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
                            Text(viewModel.totalPrice(), format: .currency(code: "VND"))
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
                    
                    //                        Spacer()
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
                    
                    Text(viewModel.totalPrice(), format: .currency(code: "VND"))
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
            viewModel.createOrderRequest = CreateOrderRequest(totalPrice: viewModel.totalPrice(), deliveryFee: 0, deliveryAddress: "ASDASD", paymentId: 1, orderDetails: viewModel.selectedOrder)
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text("\(viewModel.message)"), dismissButton: .cancel())
        }
    }
}

#Preview {
    OrderDetailsScreen(viewModel: CartViewModel())
}
