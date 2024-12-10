//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ItemBuyScreen: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = ItemBuyViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .leading)
                }
                
                SearchBar(searchText: $viewModel.searchText)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.search(text: viewModel.searchText)
                    }
            }// HEADER HSTACK
            .padding(.horizontal)
            .foregroundStyle(.black)
            
            Menu {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button {
                        viewModel.searchText = ""
                        viewModel.selectedCategory = category
                        viewModel.resetPagination()
                        viewModel.loadMorePlantsForCate(typeEcommerceId: 1)
                    } label: {
                        Text(category.title)
                    }
                }
            } label: {
                ZStack {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text(viewModel.selectedCategory?.title ?? "Phân loại")
                    }
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                }
            }
            .font(.title2)
            .padding(.horizontal)
            .disabled(viewModel.isCategoriesLoading)
            .foregroundStyle(viewModel.isCategoriesLoading ? .gray : .black)
            
//            if viewModel.isLoading {
//                LoadingCenterView()
//            } else 
            if viewModel.plants.isEmpty {
                CenterView {
                    Text("Không tìm thấy kết quả")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(viewModel.plants, id: \.self) { plant in
                                NavigationLink {
                                    ItemDetailScreen(id: plant.id)
                                } label: {
                                    ToBuyItem(imageUrl: plant.mainImage, itemName: plant.name, price: plant.finalPrice)
                                        .onAppear(perform: {
                                            if plant == viewModel.plants.last {
                                                viewModel.loadMorePlantsForCate(typeEcommerceId: 1)
                                            }
                                        })
                                    
                                }
                            }
                            .redacted(reason: viewModel.isLoading ? .placeholder : .privacy)
                        }
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        
                        Text("Hết")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .opacity(viewModel.isLastPage ? 1 : 0)
                }// ITEM SCROLL VIEW
                .padding(.horizontal)
            }
            
            Spacer()
            
        }
        .foregroundStyle(.black)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.recommendOption = .forBuy
            if !viewModel.searchText.isEmpty {
                viewModel.search(text: viewModel.searchText)
            }
            viewModel.getListCategory()
            viewModel.resetPagination()
            viewModel.loadMorePlants(typeEcommerceId: 1)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    ItemBuyScreen()
}
