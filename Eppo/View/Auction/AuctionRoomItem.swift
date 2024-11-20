//
//  AuctionRoomItem.swift
//  Eppo
//
//  Created by Letter on 16/09/2024.
//

import SwiftUI

struct AuctionRoomItem: View {
    // MARK: - PROPERTY
    let imageURL: String
    var itemName: String
    var roomNumber: String
    var time: Date
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CustomAsyncImage(imageUrl: imageURL, width: 164, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(spacing: 4) {
                    Text("Thời gian: ")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundStyle(.gray)
                    
                    Text(time, format: .dateTime)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.red)
                }
                
                Text(itemName)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                
                
                HStack(alignment: .center) {
                    VStack(alignment: .trailing) {
                        Text("Phòng")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.gray)
                        
                        Text(roomNumber)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        Color.purple
                        Text("Tham gia")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .frame(width: 56, height: 24, alignment: .trailing)
                }
                .frame(width: 140)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: .black.opacity(0.5), radius: 2, y: 4)
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionRoomItem(imageURL: "https://www.hackingwithswift.com/samples/paul2.jpg", itemName: "Sen Đá Kim Cương Haworthia Cooperi", roomNumber: "P100", time: Date())
}
