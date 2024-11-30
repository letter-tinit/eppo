//
//  OwnerHome.swift
//  Eppo
//
//  Created by Letter on 23/10/2024.
//

import SwiftUI

enum TypeEcommerce: String, CaseIterable {
    case buy = "Cây mua"
    case hire = "Cây thuê"
    case auction = "Cây đấu giá"
}

struct OwnerHome: View {
    @State var viewModel: OwnerHomeViewModel = OwnerHomeViewModel()
    
    @State var searchText: String = ""
    @State private var date = Date()
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            SingleHeaderView(title: "Cây của tôi")
            
            HStack {
                ForEach(TypeEcommerce.allCases, id: \.self) { typeEcommerce in
                    Button {
                        withAnimation {
                            viewModel.selectedType = typeEcommerce
                        }
                    } label: {
                        Text(typeEcommerce.rawValue)
                            .lineLimit(1)
                            .scaledToFill()
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(viewModel.selectedType == typeEcommerce ? .blue : .gray)
                                    .opacity(0.6)
                            )
                            .padding(8)
                    }
                }
            }
            
            // MARK: - SEARCH BAR
//            HStack(spacing: 14) {
//                SearchBar(searchText: $searchText)
//                
//                Image(systemName: "calendar")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 30, height: 30)
//                    .foregroundStyle(.black)
//                    .overlay {
//                        DatePicker(selection: $date, displayedComponents: .date) {}
//                            .labelsHidden()
//                            .contentShape(Rectangle())
//                            .opacity(0.011)
//                    }
//                Button {
//                    
//                } label: {
//                    Image(systemName: "slider.horizontal.3")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//                        .foregroundStyle(.black)
//                }
//            }
//            .padding()
            
            // MARK: - CONTENT
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        Section {
                            ForEach(viewModel.plants, id: \.self) { plant in
                                NavigationLink {
                                    OwnerItemDetailScreen()
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Image("sample-bonsai-01")
                                            .resizable()
                                            .frame(width: 160, height: 100, alignment: .top)
                                            .scaledToFit()
                                            .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 5){
                                            Text(plant.name)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("30/07/2024  - 10:35:50")
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                            
                                            Text("Đang cho thuê")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.blue)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 10)
                                    }
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .shadow(color: .black.opacity(0.5), radius: 2, y: 4)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 100)
                    .background(.white)
                }
                
                CenterView {
                    Text("Không tìm thấy dữ liệu")
                }
                .opacity((viewModel.hasError && !viewModel.isLoading) ? 1 : 0)
                
                LoadingCenterView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            }
            .padding()
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getOwnerPlant()
        }
        .onChange(of: viewModel.selectedType) { _, _ in
            viewModel.getOwnerPlant()
        }
    }
}

#Preview {
    OwnerHome()
}
