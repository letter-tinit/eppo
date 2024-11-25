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
        VStack(alignment: .leading) {
            CustomHeaderView(title: "Thông tin thanh toán")
            
            Text("Nhập số tiền cần nạp")
                .font(.headline)
                .fontWeight(.medium)
                .padding()
            BorderTextField {
                TextField("Nhập số tiền", text: $viewModel.amountInput)
                    .keyboardType(.numberPad)
            }
            .frame(height: 50)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                viewModel.createTransaction()                
            } label: {
                Text("Nạp")
                    .font(.headline)
                    .fontWeight(.medium)
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
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - PREVIEW
#Preview {
    PaymentScreen()
}
