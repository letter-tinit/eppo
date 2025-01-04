//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CartItemView: View {
    // MARK: - PROPERTIES
    @Binding var plant: Plant
    @State private var isNavigating: Bool = false

    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                CustomCircleAsyncImage(imageUrl: plant.plantUser?.imageUrl, size: 24)
                
                Text(plant.plantUser?.fullName ?? "Không xác định")
                    .font(.headline)
                    .foregroundStyle(.darkBlue)
                
                Spacer()
            }
            .padding(8)
            .contentShape(Rectangle())
            .onTapGesture {
                isNavigating.toggle()
            }
            
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
                //            Image("sample-bonsai")
                //                .resizable()
                //                .frame(width: 80, height: 80)
                //                .clipped()
                //                .clipShape(RoundedRectangle(cornerRadius: 6))
                CustomAsyncImage(imageUrl: plant.mainImage, width: 80, height: 80)
                
                VStack(alignment: .leading) {
                    Text(plant.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(plant.description)
                        .lineLimit(2)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                        .font(.caption)
                    
                    Text(plant.finalPrice, format: .currency(code: "VND"))
                        .lineLimit(1)
                        .fontWeight(.medium)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(8)
            .background(.white)
        }
        .navigationDestination(isPresented: $isNavigating) {
            ShopPlantScreen(userName: plant.plantUser?.fullName ?? "Không xác định", imageUrl: plant.plantUser?.imageUrl ?? "NA", code: plant.code)
        }
    }
}
