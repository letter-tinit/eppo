//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

// MARK: - ENUM
enum TransactionHistoryType: String, CaseIterable {
    case all = "Tất cả"
    case depositMoney = "Nạp tiền"
    case withdrawMoney = "Rút tiền"
    case payment = "Thanh toán"
    
    var flag: String {
        return self.rawValue
    }
}

struct TransactionTypeStack: View {
    // MARK: - PROPERTY
    @Namespace private var animation
    
    @Binding var selectedTransactionType: TransactionHistoryType

    // MARK: - BODY

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TransactionHistoryType.allCases, id: \.self) { transactionType in
                    Button {
                        withAnimation {
                            selectedTransactionType = transactionType
                        }
                    } label: {
                        Text(transactionType.flag)
                            .padding(8)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .foregroundColor(selectedTransactionType == transactionType ? .white : .primary)
                    .frame(width: 140)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTransactionType == transactionType ? Color.blue : Color.gray.opacity(0.2))
                    )
                    .padding(.vertical, 10)
                    .padding(transactionType == .all ? .leading : [])
                    .padding(transactionType == .payment ? .trailing : [])
                    .matchedGeometryEffect(id: transactionType, in: animation, isSource: selectedTransactionType == transactionType)
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    TransactionTypeStack(selectedTransactionType: .constant(.all))
}
