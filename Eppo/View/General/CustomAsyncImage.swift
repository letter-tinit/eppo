//
//  CustomAsyncImage.swift
//  Eppo
//
//  Created by Letter on 19/11/2024.
//

import SwiftUI

struct CustomAsyncImage: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl), transaction: .init(animation: .bouncy(duration: 1))) { phase in
            switch phase {
            case .failure:
                VStack(spacing: 20) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
//                    
//                    Text("Tải ảnh thất bại")
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
            default:
//                ZStack {
//                    Image(systemName: "photo")
//                        .font(.largeTitle)
//                        .padding(.top, 8)
//                    
//                    Text("Đang tải ảnh...")
//                    
                    ProgressView()
//                }
            }
        }
        .frame(width: width, height: height)
        .scaledToFill()
        .clipped()
    }
}

struct CustomRoundedAsyncImage: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl), transaction: .init(animation: .bouncy(duration: 1))) { phase in
            switch phase {
            case .failure:
                VStack(spacing: 20) {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .background(RoundedRectangle(cornerRadius: 6))
                        .clipped()
//
//                    Text("Tải ảnh thất bại")
                }
            case .success(let image):
                image
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .background(RoundedRectangle(cornerRadius: 6))
                    .clipped()
            default:
//                ZStack {
//                    Image(systemName: "photo")
//                        .font(.largeTitle)
//                        .padding(.top, 8)
//
//                    Text("Đang tải ảnh...")
//
                    ProgressView()
//                }
            }
        }
        .frame(width: width, height: height)
        .scaledToFill()
        .clipped()
    }
}

#Preview {
    CustomAsyncImage(imageUrl: "https://www.hackingwithswift.com/samples/paul2.jpg", width: 164, height: 100)
}
