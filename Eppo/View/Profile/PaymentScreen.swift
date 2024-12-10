//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct PaymentScreen: View {
    // MARK: - PROPERTY
    @State var viewModel = PaymentViewModel()

    // MARK: - BODY

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                CustomHeaderView(title: "Thông tin thanh toán")
                
                Text("Nhập số tiền cần nạp")
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
                BorderTextField {
                    TextField("Nhập số tiền", text: $viewModel.amountInput)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.amountInput) { _, newValue in
                            if newValue.count > 10 {
                                viewModel.amountInput = String(newValue.prefix(14))  // Cắt chuỗi nếu vượt quá giới hạn
                            }
                        }
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(viewModel.recommendAmounts, id: \.self) { recommendAmount in
                            Button {
                                viewModel.setAmount(amount: recommendAmount)
                            } label: {
                                Text(Int(recommendAmount), format: .currency(code: "VND"))
                                    .font(.headline)
                                    .padding(6)
                                    .background(.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width - 40)
                .frame(height: 30)
                .padding()
                .scrollIndicators(.hidden)
                
                Spacer()
                
                Button {
                    viewModel.createZalopayTransaction()
                } label: {
                    HStack {
                        Image("zalopay")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        Text("Nạp")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.green)
                    )
                    .padding()
                    .foregroundStyle(.white)
                }
            }
            
            LoadingCenterView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.message), dismissButton: .default(Text("Xác nhận"), action: {
                if viewModel.isSucessCreation {
                    viewModel.openZaloPay()
                }
            }))
        }
        .onChange(of: viewModel.amountInput) { _, _ in
            viewModel.setRcommendAmount()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PaymentScreen()
}
