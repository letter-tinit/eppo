//
//  PaymentViewModel.swift
//  Eppo
//
//  Created by Letter on 23/11/2024.
//

import Foundation
import zpdk
import UIKit
import Observation
import Combine

@Observable
class PaymentViewModel: NSObject, ZPPaymentDelegate {
    var amountInput: String = ""
    var zpTransToken: String = ""
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - ZPPaymentDelegate methods
    func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        print("Payment Succeeded")
        // Xử lý khi thanh toán thành công
    }
    
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        print("Payment Canceled")
        // Xử lý khi thanh toán bị hủy
    }
    
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        print("Payment Error: \(errorCode)")
        // Xử lý khi có lỗi trong thanh toán
    }
    
    // MARK: - Mở ZaloPay để thanh toán
    func openZaloPay() {
        ZaloPaySDK.sharedInstance()?.initWithAppId(553, uriScheme: "testcheme", environment: .sandbox)
        ZaloPaySDK.sharedInstance()?.paymentDelegate = self
        
        // Giả sử bạn đã lấy zpTransToken từ server trước khi gọi payOrder
        ZaloPaySDK.sharedInstance()?.payOrder(zpTransToken)
    }
    
    func createTransaction() {
        guard let walletId = UserSession.shared.myInformation?.wallet?.walletId,
              let amount = Double(amountInput) else {
            return
        }
        
        APIManager.shared.createTransaction(walletId: walletId, amount: amount)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { result in
                print(result)
                if let zpTransToken = result.zp_trans_token {
                    self.zpTransToken = zpTransToken
                }
                self.openZaloPay()
            }
            .store(in: &cancellables)
    }
}
