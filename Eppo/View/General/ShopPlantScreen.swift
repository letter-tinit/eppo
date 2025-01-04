//
// Created by Treasure Letter ♥
// 
// https://github.com/letter-tinit
//

import SwiftUI

struct ShopPlantScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel: ShopPlantViewModelProtocol = ShopPlantViewModel()
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]

    // MARK: - BODY

    var body: some View {
//        Picker(selection: $viewModel.plantTypeSelection) {
//            ForEach(PlantTypeSelection.allCases, id: \.self) { plantTypeSelection in
//                Text(plantTypeSelection.rawValue)
//            }
//        } label: {
//            Text("Loại cây")
//        }
//        .pickerStyle(.segmented)
        VStack {
            ShopPlantHeader()

            HStack {
                Spacer()
                
                ForEach(PlantTypeSelection.allCases, id: \.self) { plantTypeSelection in
                    Spacer()
                    
                    Button {
                        withAnimation {
                            viewModel.plantTypeSelection = plantTypeSelection
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(plantTypeSelection.rawValue)
                                .font(.headline)
                                .frame(width: 90)
                                .foregroundStyle(.black)
                            
                            Rectangle()
                                .frame(height: 2.8)
                                .foregroundStyle(
                                    viewModel.plantTypeSelection == .buy ?
                                    LinearGradient(colors: [.yellow, .orange], startPoint: .bottomLeading, endPoint: .topTrailing) :
                                        LinearGradient(colors: [.orange, .red], startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                .opacity(viewModel.plantTypeSelection == plantTypeSelection ? 1 : 0)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            ScrollView (.vertical) {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    if viewModel.isLoading {
                        ForEach(1..<10, id: \.self) { index in
                            ToBuyItem(imageUrl: "NA", itemName: "Plant Name", price: 999999)
                                .redacted(reason: .placeholder)
                        }
                    } else {
                        if viewModel.plantTypeSelection == .buy {
                            ForEach(viewModel.plants, id: \.self) { plant in
                                NavigationLink {
                                    ItemDetailScreen(id: plant.id)
                                } label: {
                                    ToBuyItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
                                }
                            }
                        } else if viewModel.plantTypeSelection == .hire {
                            ForEach(viewModel.hirePlants, id: \.self) { plant in
                                NavigationLink {
                                    HireItemDetailScreen(id: plant.id)
                                } label: {
                                    ToHireItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
                                }
                            }
                        } else {
                            CenterView {
                                Text("Lỗi không xác định")
                            }
                        }
                        
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            viewModel.getPlants()
        }
        .onChange(of: viewModel.plantTypeSelection) { _, _ in
            viewModel.getPlants()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ShopPlantScreen()
}

struct ShopPlantHeader: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                
            } label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            
            Spacer()
            
            Text("Nguyễn Trung Tín")
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
            
            Spacer()
            
            CircleImageView(image: Image("avatar"), size: 30)
            
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 60, alignment: .bottom)
        .padding()
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .bottomLeading, endPoint: .topTrailing)
        )
    }
}
