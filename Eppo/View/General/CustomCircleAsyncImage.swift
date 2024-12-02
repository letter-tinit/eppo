//
//  CustomCircleAsyncImage.swift
//  Eppo
//
//  Created by Letter on 21/11/2024.
//

import SwiftUI
import Kingfisher

struct CustomCircleAsyncImage: View {
    let imageUrl: String?
    let size: CGFloat
    
    var body: some View {
        KFImage(URL(string: imageUrl ?? ""))
            .placeholder {
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
            }
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
//        if let imageUrl = self.imageUrl {
//            AsyncImage(url: URL(string: imageUrl), transaction: .init(animation: .bouncy(duration: 1))) { phase in
//                switch phase {
//                case .failure:
//                    VStack(spacing: 20) {
//                        Image(systemName: "photo")
//                            .font(.largeTitle)
//                        
//                        Text("Tải ảnh thất bại")
//                    }
//                    .frame(width: size, height: size)
//                    .background(Color.gray.opacity(0.2))
//                    .clipShape(Circle())
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: size, height: size)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
//                default:
//                    VStack(spacing: 6) {
//                        Image(systemName: "photo")
//                            .font(.largeTitle)
//                            .padding(.top, 8)
//                        
//                        Text("Đang tải ảnh...")
//                        
//                        ProgressView()
//                    }
//                    .frame(width: size, height: size)
//                    .background(Color.gray.opacity(0.2))
//                    .clipShape(Circle())
//                }
//            }
//        } else {
//            Image("avatar")
//                .resizable()
//                .scaledToFit()
//                .frame(width: size, height: size)
//                .clipShape(
//                    Circle()
//                )
//                .clipped()
//                .overlay(Circle().stroke(Color.gray.opacity(0.7), lineWidth: 0.5))
//        }
    }
}

// MARK: PREVIEW
#Preview {
    CustomCircleAsyncImage(imageUrl: "https://www.hackingwithswift.com/samples/paul2.jpg", size: 100)
}
