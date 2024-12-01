//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI



struct RecomendGrid: View {
    // MARK: - PROPERTY
    @ObservedObject var viewModel: HomeViewModel
    
    @State var recomendOption: RecomendOption = .forBuy
    
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        RecommendSectionHeader(selectedOption: $recomendOption)
            .disabled(viewModel.isLoading)
        
        ScrollView {
            LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                Section {
                    ForEach(viewModel.plants, id: \.self) { plant in
                        if recomendOption == .forBuy {
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
                        } else {
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
                    }
                }
            }
            .padding()
            
            Text("Hết")
                .font(.caption)
                .foregroundStyle(.secondary)
                .opacity(viewModel.isLastPage ? 1 : 0)
                .padding(.bottom)
        }
        .background(.white)
        .padding(.bottom, 80)
        .refreshable {
            viewModel.resetPagination()
            loadMorePlant()
        }
        .onAppear {
            viewModel.resetPagination()
            loadMorePlant()
        }
        .onChange(of: recomendOption, initial: true) { oldValue, newValue in
            viewModel.resetPagination() // Reset for new recommendation type
            loadMorePlant()
        }
    }
    
    private func loadMorePlant() {
        viewModel.loadMorePlants(typeEcommerceId: recomendOption == .forBuy ? 1 : 2)
    }
}

// MARK: - PREVIEW
#Preview {
    RecomendGrid(viewModel: HomeViewModel())
}
