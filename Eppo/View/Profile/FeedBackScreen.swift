//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct FeedBackScreen: View {
    // MARK: - PROPERTY
    @State private var viewModel = FeedBackViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomHeaderView(title: "Đánh giá")
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach (viewModel.plants) { plant in
                        FeedBackItem(viewModel: viewModel, plant: plant)
                            .padding(10)
                    }
                    .background(Color(uiColor: UIColor.systemGray5))
                }
            }
            .blur(radius: viewModel.isLoading ? 2 : 0)
            .disabled(viewModel.isLoading)
            
            CenterView {
                Text("Không có cây nào chờ đánh giá")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
            .opacity(viewModel.isEmptyData() ? 1 : 0)
            
            LoadingCenterView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .padding(.bottom, 30)
        .background(.white)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .vertical)
        .onAppear {
            viewModel.getFeedBackOrder()
        }
    }
}

// MARK: - PREVIEW
#Preview {
    FeedBackScreen()
}
