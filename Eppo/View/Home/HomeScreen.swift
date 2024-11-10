//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct HomeScreen: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = HomeViewModel()
    @State private var searchText = ""

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack(spacing: 2) {
                HomeHeader()

                RecomendGrid(viewModel: viewModel)
                
                Spacer()
                
            }
            .background(Color.init(uiColor: UIColor.systemGray5))
            .ignoresSafeArea(.all)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HomeScreen()
}
