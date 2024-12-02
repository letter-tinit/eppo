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
        if imagePlants.isEmpty {
            Image("no-image")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.horizontal, 10)
        } else {
            TabView {
                ForEach(imagePlants, id: \.self) { imagePlant in
                    CustomAsyncImage(imageUrl: imagePlant.imageUrl, width: UIScreen.main.bounds.size.width - 20, height: 200)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PictureSlider(imagePlants: [
        ImagePlantResponse(id: 1, imageUrl: "https://pixlr.com/images/generator/text-to-image.webp"),
        ImagePlantResponse(id: 1, imageUrl: "https://fps.cdnpk.net/images/home/subhome-ai.webp?w=649&h=649")
    ]
    )
}
