//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ReviewRentalPlantScreen: View {
    @State var viewModel: ReviewRentalPlantViewModel
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Thanh Toán")
            ScrollView(.vertical) {
                VStack {
                    AddressOrderView()
                        .padding(.horizontal)
                    
                    VStack {
                        OrderItemView(plant: viewModel.plant)
                            .background(Color.clear)
                        
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
                        
                        HStack {
                            Text("Phí vận chuyển:")
                            
                            Spacer()
                            
                            Text(viewModel.deliveriteFree, format: .currency(code: "VND"))
                        }
                        .listRowSeparator(.hidden, edges: .bottom)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .listStyle(.inset)
                    .scrollDisabled(true)
                    VStack(alignment: .leading, spacing: 10) {
                        NavigationLink {
                            //                            ContractScreen(viewModel: viewModel)
                            ReviewContractScreen(contractUrl: viewModel.contractUrl, isSigned: $viewModel.isSigned)
                        } label: {
                            Text("Xem hợp đồng")
                                .font(.headline)
                                .underline()
                                .foregroundStyle(viewModel.contractUrl == nil ? .gray : .blue)
                        }
                        .disabled(viewModel.contractUrl == nil)
                        
                        Divider()
                        
                        HStack {
                            Text("Trạng thái hợp đồng:")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text(viewModel.isSigned ? "Đã ký" : "Chưa ký")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(viewModel.isSigned ? .green : .red)
                        }
                    }
                    .padding()
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
                    Text(viewModel.rentTotalPrice, format: .currency(code: "VND"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                }
                
                Button {
                    viewModel.updatePaymentStatus(paymentId: 2)
                } label: {
                    Text("Thanh toán")
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: 140, height: 40)
                        .background(viewModel.isSigned ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(.white)
                }
                .disabled(!viewModel.isSigned)
            }
            .padding()
            .background(.white)
        }
        .navigationBarBackButtonHidden()
        .background(Color(uiColor: UIColor.systemGray5))
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.createContract()
        }
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .cancel())
        }
    }
}

// MARK: - PREVIEW
//#Preview {
//    ReviewRentalPlantScreen()
//}
