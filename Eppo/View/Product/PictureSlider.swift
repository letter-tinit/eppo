//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI
import Kingfisher

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
                    CustomPictureSliderImage(imageUrl: imagePlant.imageUrl)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 200)
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
    }
}

struct CustomPictureSliderImage: View {
    let imageUrl: String
    
    var body: some View {
        ZStack {
            Color.black
            
            KFImage(URL(string: imageUrl))
                .placeholder {
                    Image("no-image")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
        }
        .frame(width: UIScreen.main.bounds.size.width - 20, height: 300)
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
