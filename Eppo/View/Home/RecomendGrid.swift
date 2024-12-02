//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI



struct RecomendGrid: View {
    // MARK: - PROPERTY
    @ObservedObject var viewModel: HomeViewModel
    
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        RecommendSectionHeader(selectedOption: $viewModel.recomendOption)
            .disabled(viewModel.isLoading)
        
        ScrollView {
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                Section {
                    if viewModel.recomendOption == .forBuy {
                        ForEach(viewModel.plants, id: \.self) { plant in
                            NavigationLink {
                                ItemDetailScreen(id: plant.id)
                            } label: {
                                ToBuyItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
                                    .onAppear {
                                        if plant == viewModel.plants.last {
                                            loadMorePlant()
                                        }
                                    }
                                    .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                            }
                        }
                    } else if viewModel.recomendOption == .forHire {
                        ForEach(viewModel.hirePlants, id: \.self) { plant in
                            NavigationLink {
                                HireItemDetailScreen(id: plant.id)
                            } label: {
                                ToHireItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
                                    .onAppear {
                                        if plant == viewModel.plants.last {
                                            loadMorePlant()
                                        }
                                    }
                                    .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                            }
                        }
                    } else {
                        CenterView {
                            Text("Lỗi không xác định")
                        }
                    }
                        
//                    ForEach(viewModel.plants, id: \.self) { plant in
//                        if recomendOption == .forBuy {
//                            NavigationLink {
//                                ItemDetailScreen(id: plant.id)
//                            } label: {
//                                ToBuyItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
//                                    .onAppear {
//                                        if plant == viewModel.plants.last {
//                                            loadMorePlant()
//                                        }
//                                    }
//                                    .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
//                            }
//                        } else {
//                            NavigationLink {
//                                HireItemDetailScreen(id: plant.id)
//                            } label: {
//                                ToHireItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
//                                    .onAppear {
//                                        if plant == viewModel.plants.last {
//                                            loadMorePlant()
//                                        }
//                                    }
//                                    .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
//                            }
//                        }
//                    } // FOREACH
                }
            }
            .padding()
            
        }
        .background(.white)
        .refreshable {
            viewModel.resetPagination()
            loadMorePlant()
        }
        .onAppear {
            switch viewModel.recomendOption {
            case .forBuy:
                if !viewModel.isBuyDataLoaded {
                    viewModel.resetPagination()
                    loadMorePlant()
                }
            case .forHire:
                if !viewModel.isHireDataLoaded {
                    viewModel.resetPagination()
                    loadMorePlant()
                }
            }
        }
        .onChange(of: viewModel.recomendOption, initial: true) { oldValue, newValue in
            switch newValue {
            case .forBuy:
                if !viewModel.isBuyDataLoaded {
                    viewModel.resetPagination()
                    loadMorePlant()
                }
            case .forHire:
                if !viewModel.isHireDataLoaded {
                    viewModel.resetPagination()
                    loadMorePlant()
                }
            }
        }
    }
    
    private func loadMorePlant() {
        viewModel.loadMorePlants()
    }
}

// MARK: - PREVIEW
#Preview {
    RecomendGrid(viewModel: HomeViewModel())
}
