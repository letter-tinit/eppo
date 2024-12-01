//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ReviewRentalPlantScreen: View {
    @State var viewModel: ReviewRentalPlantViewModel
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        ZStack {
            VStack {
                CustomHeaderView(title: "Thanh Toán")
                ScrollView(.vertical) {
                    VStack {
                        //                    AddressOrderView()
                        //                        .padding(.horizontal)
                        Text("Địa chỉ: \(viewModel.deliveryAddress)")
                            .padding(14)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                        
                        VStack {
                            OrderItemView(plant: viewModel.plant)
                                .background(Color.clear)
                            
                            Divider()
                                .padding(.horizontal, -14)
                                .padding(.vertical, 10)
                            
                            HStack {
                                Text("Phí vận chuyển:")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                
                                Spacer()
                                
                                Text(viewModel.deliveriteFree, format: .currency(code: "VND"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            
                            Divider()
                                .padding(.horizontal, -14)
                                .padding(.vertical, 10)
                            
                            HStack {
                                Text("Giá Thuê")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                Spacer()
                                HStack(spacing: 0) {
                                    Text(viewModel.plant.finalPrice, format: .currency(code: "VND"))
                                    
                                    Text("/tháng")
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            }
                        }
                        .padding(14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        
                        List {
                            HStack {
                                Text("Thanh toán bằng ví")
                                
                                Spacer()
                                
                                Image(systemName: "creditcard.fill")
                                    .foregroundStyle(.red)
                            }
                            .listRowSeparator(.hidden, edges: .bottom)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
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
                        Text(viewModel.rentTotalPrice, format: .currency(code: "VND"))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                    
                    if viewModel.isSigned {
                        Button {
                            viewModel.updatePaymentStatus(paymentId: 2)
                        } label: {
                            Text("Thanh toán")
                                .fontWeight(.medium)
                                .padding()
                                .frame(width: 140, height: 40)
                                .background(
                                    LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
                    } else {
                        NavigationLink {
                            ReviewContractScreen(viewModel: viewModel)
                        } label: {
                            Text("Đặt hàng")
                                .fontWeight(.medium)
                                .padding()
                                .frame(width: 140, height: 40)
                                .background(
                                    LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                        }
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
            viewModel.createContract()
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .cancel({
                self.dissmiss()
            }))
        }
    }
}

// MARK: - PREVIEW
//#Preview {
//    ReviewRentalPlantScreen()
//}
