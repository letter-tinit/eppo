//
//  CashOutViewModel.swift
//  Eppo
//
//  Created by Letter on 07/12/2024.
//

import Foundation
import Combine
import Observation

enum CashActiveAlert {
    case remind
    case error
    case success
}

@Observable
class CashOutViewModel {
    var cancellables: Set<AnyCancellable> = []
    var selectedCashActiveAlert: CashActiveAlert = .remind
    var cashOutAmountText: String = ""
    var cashOutAmount: Int = 0
    var recommendAmounts: [Int] = []
    var isShowingAlert: Bool = false
    var errorMessage: String?
    
    func cashOut() {
        print("Cash Out")
        
    }
    
    func validate() {
        if cashOutAmountText.isEmpty {
            selectedCashActiveAlert = .error
            errorMessage = "Vui lòng nhập số tiền cần rút"
            isShowingAlert = true
        } else if let cashOutAmount = Int(cashOutAmountText) {
            self.cashOutAmount = cashOutAmount
            selectedCashActiveAlert = .remind
            errorMessage = "Bạn có chắc muốn rút \(cashOutAmount.formatted(.currency(code: "VND")))"
            isShowingAlert = true
        } else {
            selectedCashActiveAlert = .error
            errorMessage = "Dữ liệu nhập vào không đúng"
            isShowingAlert = true
        }
    }
    
    func setRcommendAmount() {
        var result = [Int]()
        guard let cashOutAmount = Int(cashOutAmountText) else {
            recommendAmounts = []
            return
        }
        
        for i in 1..<4 {
            let value = cashOutAmount * Int(pow(10.0, Double(i)))
            result.append(value)
        }
        
        recommendAmounts = result
    }
    
    func setAmount(amount: Int) {
        cashOutAmountText = String(describing: amount)
    }
}
