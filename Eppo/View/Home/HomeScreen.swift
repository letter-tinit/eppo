//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct HomeScreen: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = HomeViewModel()

    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 2) {
            HomeHeader(viewModel: viewModel)
            
            RecomendGrid(viewModel: viewModel)
        }
        .background(Color.init(uiColor: UIColor.systemGray5))
        .ignoresSafeArea(.container, edges: .top)
        .onDisappear {
            viewModel.isBuyDataLoaded = false
            viewModel.isHireDataLoaded = false
        }
        .navigationDestination(isPresented: $viewModel.navigateToResults) {
            switch viewModel.recomendOption {
            case .forBuy:
                ItemBuyScreen(viewModel: ItemBuyViewModel(searchText: viewModel.searchText, recommendOption: .forBuy))
            case .forHire:
                ItemHireScreen(viewModel: ItemBuyViewModel(searchText: viewModel.searchText, recommendOption: .forHire))
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HomeScreen()
}
