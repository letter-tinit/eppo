//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct BuyOrderDetailsScreen: View {
    @Bindable var viewModel: ItemDetailsViewModel
    @State var isReturnHome: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                CustomHeaderView(title: "Thanh Toán")
                ScrollView(.vertical) {
                    VStack {
                        //                    AddressOrderView()
                        //                        .padding(.horizontal)
                        
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
                        
                        VStack {
                            if let plant = viewModel.plant {
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
                            Picker(selection: $viewModel.selectedPaymentMethod) {
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
                                Text(viewModel.selectedPaymentMethod.rawValue)
                                
                                Spacer()
                                
                                Image(systemName: viewModel.selectedPaymentMethod == .cashOnDelivery ? "coloncurrencysign.circle" : "creditcard.fill")
                                    .foregroundStyle(viewModel.selectedPaymentMethod == .cashOnDelivery ? .green : .red)
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
                        
                        HStack {
                            Text("Phí vận chuyển")
                            
                            Spacer()
                            
                            Text(viewModel.deliveriteFree, format: .currency(code: "VND"))
                        }
                        .padding(14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        
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
            
            CustomLoadingCenterView(title: "Đang xử lý")
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .navigationBarBackButtonHidden()
        .background(Color(uiColor: UIColor.systemGray6))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            if viewModel.addresses.isEmpty {
                viewModel.getAddress()
            }
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text("\(viewModel.message)"), dismissButton: .cancel(Text("Đóng"), action: {
                if viewModel.isFinishPayment {
                    self.isReturnHome = true
                }
            }))
        }
        .navigationDestination(isPresented: $isReturnHome) {
            MainTabView(selectedTab: .explore)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    BuyOrderDetailsScreen(viewModel: ItemDetailsViewModel())
}
