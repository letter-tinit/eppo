//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct OrderItemView: View {
    // MARK: - PROPERTIES
    var plant: Plant
    
    // MARK: - BODY
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
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
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CartOrderItemView: View {
    // MARK: - PROPERTIES
    @Bindable var viewModel: CartViewModel
    var plant: Plant
    @State private var shippingFee: Double?
    @State private var errorMessage: String?
    
    @State private var isNavigating: Bool = false
    
    // MARK: - BODY
    var body: some View {
        VStack {
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
                CustomAsyncImage(imageUrl: plant.mainImage, width: 90, height: 90)
                
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
                    
                    VStack {
                        if let fee = shippingFee {
                            Text("Phí vận chuyển: \(fee.formatted(.currency(code: "VND")))")
                            
                        } else if let error = errorMessage {
                            Text("Error: \(error)")
                        } else {
                            Text("Loading shipping fee...")
                        }
                    }
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .font(.caption)
                    .onAppear {
                        viewModel.getShippingFeeByPlantId(plantId: plant.id) { result in
                            switch result {
                            case .success(let fee):
                                shippingFee = fee
                                viewModel.totalShippingFee += fee
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(8)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .navigationDestination(isPresented: $isNavigating) {
            ShopPlantScreen(userName: plant.plantUser?.fullName ?? "Không xác định", imageUrl: plant.plantUser?.imageUrl ?? "NA", code: plant.code)
        }
        
    }
}

// MARK: - PREVIEW
#Preview {
    CartScreen()
}
