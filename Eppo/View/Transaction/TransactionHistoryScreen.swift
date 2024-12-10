//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct TransactionHistoryScreen: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ProfileViewModel
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - HEADER
            TransactionHeader(title: "Lịch sử giao dịch", searchText: .constant("Cây cảnh"))
            
            if viewModel.isLoading {
                CenterView {
                    ProgressView("Đang tải dữ liệu...")
                        .padding()
                }
            } else if viewModel.hasError {
                VStack(spacing: 16) {
                    Text(viewModel.errorMessage ?? "Lỗi không xác định")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                    Button("Thử lại") {
                        viewModel.getTransactionHistory()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if !viewModel.transactions.isEmpty {
                // Hiển thị nội dung khi có dữ liệu
                ScrollView(.vertical) {
                    LazyVStack(spacing: 2) {
                        ForEach(viewModel.transactions) { transaction in
                            if let withdrawDate = transaction.withdrawDate,
                               let withdrawNumber = transaction.withdrawNumber {
                                TransactionRow(transactionName: transaction.description, transactionTime: withdrawDate, transactionAmount: -withdrawNumber, isBonus: false)
                            } else if let rechargeDate = transaction.rechargeDate,
                                      let rechargeNumber = transaction.rechargeNumber {
                                TransactionRow(transactionName: transaction.description, transactionTime: rechargeDate, transactionAmount: rechargeNumber, isBonus: true)
                            }
                        }
                        .background(Color(uiColor: UIColor.systemGray4))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(.white)
                }
            } else {
                CenterView {
                    Text("Không có dữ liệu")
                }
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getTransactionHistory()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    TransactionHistoryScreen(viewModel: ProfileViewModel())
}
