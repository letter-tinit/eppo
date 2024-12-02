//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct FeedBackItem: View {
    // MARK: - PROPERTY
    @Bindable var viewModel: FeedBackViewModel
    let plant: Plant
    
    init(viewModel: FeedBackViewModel, plant: Plant) {
        self.viewModel = viewModel
        self.plant = plant
    }
    // MARK: - BODY
    
    var body: some View {
        LazyVStack(alignment: .trailing) {
            HStack(alignment: .center) {
                CustomAsyncImage(imageUrl: plant.mainImage, width: 60, height: 60)
                
                VStack(alignment: .leading) {
                    Text(plant.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(plant.finalPrice, format: .currency(code: "VND"))
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            NavigationLink {
                RatingSubmitView(viewModel: RatingSubmitViewModel(plantId: plant.id))
            } label: {
                Text("Đánh giá")
                    .frame(width: 140, height: 40)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.blue)
                    )
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 10)
        }
        .scaledToFit()
        .padding(.vertical)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .alert(isPresented: $viewModel.isAlertShowing) {
            Alert(title: Text(viewModel.errorMessage ?? "Lỗi không xác định"), dismissButton: .cancel())
        }
    }
}
