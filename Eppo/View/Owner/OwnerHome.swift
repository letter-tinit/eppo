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
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            SingleHeaderView(title: "Cây của tôi")
            
            HStack(spacing: 20) {
                ForEach(TypeEcommerce.allCases, id: \.self) { typeEcommerce in
                    Button {
                        withAnimation(.smooth(duration: 0.75)) {
                            viewModel.selectedType = typeEcommerce
                        }
                    } label: {
                        Text(typeEcommerce.rawValue)
                            .lineLimit(1)
                            .scaledToFill()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(viewModel.selectedType == typeEcommerce ? .blue : .gray)
                                    .opacity(0.6)
                            )
                            .foregroundStyle(viewModel.selectedType == typeEcommerce ? .black : .white)
                            .padding(.vertical, 10)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
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
                                    if plant.typeEcommerceId == 2 {
                                        OwnerItemDetailScreen(plant: plant)
                                    } else {
                                        SimpleOwnerItemDetailScreen(plant: plant)
                                    }
                                } label: {
                                    VStack(alignment: .leading, spacing: 5) {
                                        CustomAsyncImage(imageUrl: plant.mainImage, width: 160, height: 150)
                                        
                                        Text(plant.name)
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 10)
                                            .foregroundStyle(.black)
                                        
                                        if viewModel.selectedType == .hire {
                                            Text("\(plant.finalPrice.formatted(.currency(code: "VND")))/tháng")
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.red)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                            
                                            if plant.isActive {
                                                HStack {
                                                    Text("Có sẵn")
                                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                        .foregroundStyle(.gray)
                                                        .multilineTextAlignment(.leading)
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        viewModel.toggleRemind(plant: plant)
                                                    } label: {
                                                        Image(systemName: "trash.square.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                            } else {
                                                Text("Đang cho thuê")
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .foregroundStyle(.red)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.horizontal, 10)
                                            }
                                        } else {
                                            Text(plant.finalPrice, format: .currency(code: "VND"))
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.red)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                            
                                            if plant.isActive {
                                                HStack {
                                                    Text("Có sẵn")
                                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                        .foregroundStyle(.gray)
                                                        .multilineTextAlignment(.leading)
                                                    
                                                    Spacer()
                                                    
                                                    Button {
                                                        viewModel.toggleRemind(plant: plant)
                                                    } label: {
                                                        Image(systemName: "trash.square.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundStyle(.red)
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                            } else {
                                                Text("Đã bán")
                                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                    .foregroundStyle(.gray)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.horizontal, 10)
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(width: 160)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .shadow(color: .gray.opacity(0.4), radius: 2, y: 4)
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
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.activeAlert {
            case .remind:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? "Lỗi không xác định"), primaryButton: .destructive(Text("Huỷ")), secondaryButton: .default(Text("Xác nhận"), action: {
                    viewModel.deletePlant()
                }))
            case .error:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? "Lỗi không xác định"), dismissButton: .cancel())
            case .succcess:
                return Alert(title: Text(viewModel.activeAlert.rawValue), message: Text(viewModel.message ?? "Lỗi không xác định"), dismissButton: .cancel({
                    viewModel.getOwnerPlant()
                }))
            }
        }
    }
}

#Preview {
    OwnerHome()
}
