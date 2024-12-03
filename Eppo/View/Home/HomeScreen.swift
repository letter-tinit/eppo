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
    }
}

// MARK: - PREVIEW
#Preview {
    HomeScreen()
}
