//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct HomeScreen: View {
    // MARK: - PROPERTY
    @State private var searchText = ""

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HomeHeader()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        FlashSale()
                            .frame(height: 250)
                        
                        RecomendGrid()
                    }
                }
                .padding(.bottom)
                
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
