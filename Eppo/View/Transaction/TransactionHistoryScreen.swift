//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct TransactionHistoryScreen: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: ProfileViewModel
    @State var selectedTransactionType: TransactionHistoryType = .all
    
    @State var typeState: String = "all"
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - HEADER
            TransactionHeader(title: "Lịch sử giao dịch", searchText: .constant("Cây cảnh"))
            
            TransactionTypeStack(selectedTransactionType: $selectedTransactionType)
                .padding(.vertical, 4)

            ScrollView(.vertical) {
                LazyVStack(spacing: 2, pinnedViews: .sectionHeaders) {
                    ForEach(1 ..< 13) { index in
                    Section {
                        LazyVStack(spacing: 2) {
                            ForEach(0 ..< 3) { _ in
                                TransactionRow(transactionName: "Nạp tiền vào hệ thống EPPO", transactionTime: "12:35 - 25/07/2024", currentBalance: 1100000, transactionAmount: -100000, isBonus: false)
                                TransactionRow(transactionName: "Nạp tiền vào hệ thống EPPO", transactionTime: "12:35 - 25/07/2024", currentBalance: 1100000, transactionAmount: +100000, isBonus: true)
                            }
                        }
                        .background(Color(uiColor: UIColor.systemGray4))
                    } header: {
                        HStack {
                            Text("Tháng \(index)")
                                .foregroundStyle(Color(uiColor: UIColor.darkGray))
                            Spacer()
                            Text("2024")
                                .foregroundStyle(Color(uiColor: UIColor.systemGray5))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3)
                        .padding(8)
                        .background(
                            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
                        )
                        .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(.white)
                }
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
