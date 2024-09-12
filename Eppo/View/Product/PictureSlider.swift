//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct PictureSlider: View {
    // MARK: - PROPERTY
    @State private var currentPage = 0
    let images = ["sample-bonsai", "sample-bonsai-01"]
    
    // MARK: - BODY

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 200)
        .cornerRadius(10)
        .padding([.leading, .trailing], 10)
        .onReceive(timer) { _ in
            withAnimation {
                currentPage = (currentPage + 1) % images.count
            }
        }
    }
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
}

// MARK: - PREVIEW
#Preview {
    PictureSlider()
}
