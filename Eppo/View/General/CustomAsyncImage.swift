//
//  CustomAsyncImage.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import SwiftUI
import Kingfisher

struct CustomAsyncImage: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        KFImage(URL(string: imageUrl))
            .placeholder {
                Image("no-image")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: width, height: height)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .clipped()
    }
}

struct CustomRoundedAsyncImage: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        KFImage(URL(string: imageUrl))
            .placeholder {
                Image("no-image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            }
            .resizable()
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .clipped()
    }
}

#Preview {
    CustomAsyncImage(imageUrl: "https://www.hackingwithswift.com/samples/paul2.jpg", width: 164, height: 100)
}
