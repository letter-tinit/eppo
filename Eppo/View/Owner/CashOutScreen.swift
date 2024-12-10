//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct CashOutScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel = CashOutViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomHeaderView(title: "Rút tiền")
            
            BorderTextField {
                TextField(text: $viewModel.cashOutAmountText) {
                    Text("Nhập số tiền cần rút")
                }
                .keyboardType(.numberPad)
                .onChange(of: viewModel.cashOutAmountText) { _, newValue in
                    if newValue.count > 10 {
                        viewModel.cashOutAmountText = String(newValue.prefix(14))  // Cắt chuỗi nếu vượt quá giới hạn
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            .padding(.top)
            
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
                viewModel.validate()
            } label: {
                Text("Rút tiền")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.selectedCashActiveAlert {
            case .remind:
                return Alert(title: Text("Nhắc nhở"), message: Text(viewModel.errorMessage ?? "Lỗi không xác định"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
                    viewModel.cashOut()
                }))
            case .error:
                return Alert(title: Text("Lỗi nhập liệu"), message: Text(viewModel.errorMessage ?? "Lỗi không xác định"), dismissButton: .destructive(Text("Huỷ")))
            case .success:
                return Alert(title: Text("Đã rút tiền thành công"), dismissButton: .destructive(Text("Huỷ")))
            }
        }
        .onChange(of: viewModel.cashOutAmountText) { _, _ in
            viewModel.setRcommendAmount()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CashOutScreen()
}
