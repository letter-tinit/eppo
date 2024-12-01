//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct PictureSlider: View {
    // MARK: - PROPERTY
    @State private var currentPage = 0
    let imagePlants: [ImagePlantResponse]
    
    // MARK: - BODY

    var body: some View {
        TabView(selection: $currentPage) {
            if imagePlants.isEmpty {
                Image("no-image")
                    .resizable()
                    .scaledToFill()
            } else {
                ForEach(imagePlants) { imagePlant in
                    CustomAsyncImage(imageUrl: imagePlant.imageUrl, width: UIScreen.main.bounds.size.width - 20, height: 200)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 200)
        .cornerRadius(10)
        .padding([.leading, .trailing], 10)
//        .onReceive(timer) { _ in
//            withAnimation {
//                currentPage = (currentPage + 1) % (imagePlants.count + 1)
//            }
//        }
    }
    
//    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}

// MARK: - PREVIEW
#Preview {
    PictureSlider(imagePlants: [])
}
