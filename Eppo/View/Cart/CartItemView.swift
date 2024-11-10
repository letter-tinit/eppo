//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartItemView: View {
    // MARK: - PROPERTIES
    @Binding var plant: Plant

    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button {
                plant.isSelected.toggle()
            } label: {
                Image(systemName: plant.isSelected ? "checkmark.square.fill" : "square")
                    .fontWeight(.semibold)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(plant.isSelected ? .green : .gray)
            }
            
            // Item Image
            Image("sample-bonsai")
                .resizable()
                .frame(width: 80, height: 80)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading) {
                Text(plant.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(plant.description)
                    .lineLimit(2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .font(.caption)
                
                Text(plant.price, format: .currency(code: "VND"))
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            Spacer()
        }
        .padding(8)
        .background(.gray.opacity(0.1))
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
