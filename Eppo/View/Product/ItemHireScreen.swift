//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct ItemHireScreen: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = ItemBuyViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
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
                    
//                    Button {
//                    } label: {
//                        Image(systemName: "cart")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 30, alignment: .leading)
//                    }
//
//                    Button {
//                    } label: {
//                        Image(systemName: "message")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 30, alignment: .leading)
//                    }
                }// HEADER HSTACK
                .padding(.horizontal)
                .foregroundStyle(.black)

                Menu {
                    ForEach(viewModel.categories, id: \.self) { category in
                        Button {
                            viewModel.selectedCategory = category
                            viewModel.resetPagination()
                            viewModel.loadMorePlantsForCate(typeEcommerceId: 2)
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
                
                if !viewModel.isLoading && viewModel.plants.isEmpty {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text("Không tìm thấy kết quả")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: adaptiveColumn, spacing: 20, pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(viewModel.plants, id: \.self) { plant in
                                    NavigationLink {
                                        ItemDetailScreen(id: plant.id)
                                    } label: {
                                        ToHireItem(imageUrl: "https://hws.dev/paul2.jpg", itemName: plant.name, price: plant.price)
                                            .onAppear(perform: {
                                                if plant == viewModel.plants.last {
                                                    viewModel.loadMorePlantsForCate(typeEcommerceId: 2)
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
                viewModel.getListCategory()
                viewModel.resetPagination()
                viewModel.loadMorePlants(typeEcommerceId: 2)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW
#Preview {
    ItemHireScreen()
}
