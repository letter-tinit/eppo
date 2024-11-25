//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct TransactionRow: View {
    // MARK: - PROPERTY
    var transactionName: String
    var transactionTime: Date
    var transactionAmount: Double
    var isBonus: Bool

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 20) {
            // MARK: - Icon
            Image(systemName: "creditcard.fill")
                .font(.largeTitle)
                .foregroundStyle(
                    LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            
            VStack(alignment: .leading) {
                Text(transactionName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(transactionTime, format: .dateTime)
                    .font(.subheadline)
                
                HStack(spacing: 0) {
                    Text("Số dư ví: ")
                    
                    Text("***********")
                        .fontWeight(.bold)
                }
                .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.white)
        .overlay(alignment: .bottomTrailing) {
            HStack(alignment: .center, spacing: 0) {
                if isBonus {
                    Text("+")
                }
                
                Text(transactionAmount, format: .currency(code: "VND"))
            }
            .font(.headline)
            .fontWeight(.semibold)
            .padding([.bottom, .trailing], 10)
            .foregroundStyle(isBonus ? .green : .red)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    TransactionRow(transactionName: "Nạp tiền vào hệ thống EPPO", transactionTime: Date(), transactionAmount: -100000, isBonus: false)
}
