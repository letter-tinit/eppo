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
