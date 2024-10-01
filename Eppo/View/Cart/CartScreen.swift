//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartScreen: View {
    // MARK: - PROPERTY
    @State private var selectedOrders: [String] = []
    
    let options = ["Order 1", "Order 2", "Order 3", "Order 4"]

    // MARK: - BODY

    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "checkmark")
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            )
        }
    }
    
    func toggleSelection(for option: String) {
        if let index = selectedOrders.firstIndex(of: option) {
            selectedOrders.remove(at: index)
        } else {
            selectedOrders.append(option)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
