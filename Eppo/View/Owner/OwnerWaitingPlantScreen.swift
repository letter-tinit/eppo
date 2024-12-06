//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct OwnerWaitingPlantScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel = WaitingPlantViewModel()
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            OwnerWaitingPlantHeader(title: "Cây Chờ Duyệt")
            
            HStack(spacing: 20) {
                ForEach(PlantStatus.allCases, id: \.self) { plantStatus in
                    Button {
                        withAnimation(.smooth(duration: 0.75)) {
                            viewModel.selectedPlantStatus = plantStatus
                        }
                    } label: {
                        Text(plantStatus.rawValue)
                            .lineLimit(1)
                            .scaledToFill()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(viewModel.selectedPlantStatus == plantStatus ? .blue : .gray)
                                    .opacity(0.6)
                            )
                            .foregroundStyle(viewModel.selectedPlantStatus == plantStatus ? .black : .white)
                            .padding(.vertical, 10)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // MARK: - CONTENT
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        Section {
                            ForEach(viewModel.plants, id: \.self) { plant in
                                NavigationLink {
                                    SimpleOwnerItemDetailScreen(plant: plant)
                                } label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        CustomAsyncImage(imageUrl: plant.mainImage, width: 160, height: 150)
                                        
                                        Text(plant.name)
                                            .font(.system(size: 17, weight: .medium, design: .rounded))
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 10)
                                            .foregroundStyle(.black)
                                        
                                        
                                        if plant.typeEcommerceId == 2 {
                                            Text("\(plant.finalPrice.formatted(.currency(code: "VND")))/tháng")
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.red)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                                .padding(.bottom, 10)
                                        } else {
                                            Text(plant.finalPrice, format: .currency(code: "VND"))
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundStyle(.red)
                                                .multilineTextAlignment(.leading)
                                                .padding(.horizontal, 10)
                                                .padding(.bottom, 10)
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
        }
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            viewModel.getPlants()
        }
        .onChange(of: viewModel.selectedPlantStatus) { _, _ in
            viewModel.getPlants()
        }
    }
}

struct OwnerWaitingPlantHeader: View {
    // MARK: - PROPERTY
    var buttonWidth: CGFloat = 16
    
    var title: String
    
    
    // MARK: - BODY
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonWidth, alignment: .leading)
                    .opacity(0)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 240)
                .lineLimit(1)
                .frame(alignment: .center)
                .padding(.leading, buttonWidth)
                .padding(.bottom, 6)
            
            Spacer()
            
            NavigationLink {
                OwnerItemAdditionScreen()
            } label: {
                ZStack {
                    Image(systemName: "tree")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .leading)
                    
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                }
                .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 20)
        .foregroundStyle(.white)
        .frame(width: UIScreen.main.bounds.size.width, height: 90, alignment: .bottom)
        .padding(.bottom, 10)
        .background(
            LinearGradient(colors: [.lightBlue, .darkBlue], startPoint: .leading, endPoint: .trailing)
        )
    }
}

// MARK: - PREVIEW
#Preview {
    OwnerWaitingPlantScreen()
}
